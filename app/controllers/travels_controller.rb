class TravelsController < ApplicationController
	def index
        @ticket = Ticket.new
		if current_user != nil 
            if current_user.role == "admin"
                @travels = Travel.pending
            else
                if current_user.role == "driver"
                    redirect_to booked_travels_path
                end
            end
        end
        if current_user == nil || current_user.role == "user"
            @searchedTravels = Travel.future
            if params[:search] && params[:search][:route_id] != ""
                @searchedTravels = @searchedTravels.where({route_id: params[:search][:route_id]})
            end
            if params[:date_search] && !params[:dont_know_date]
                @date = params[:date_search].to_date
                @searchedTravels = @searchedTravels.where(date_departure: @date.all_day)
            end
            if current_user != nil
                @travels = []
                @searchedTravels.each do |travel|
                    if !current_user.travels.include?travel
                        @travels.push(travel)
                    end
                end
            else
                @travels = @searchedTravels
            end
            render 'clients_index'
        end
        #render 'prueba'
	end

    def previous
        @travels = Travel.previous
        if current_user != nil && current_user.role == "admin"
            render 'index'
        end
    end

    def history
        if current_user == nil
            redirect_to root_path
        else
            if current_user.role == 'driver'
                @travels = current_user.driving_travels.previous
            else
                @travels = current_user.confirmed_travels
            end
        end
    end

    def discarded
        if current_user == nil
            redirect_to root_path
        else
            @travels = current_user.rejected_travels + current_user.absent_travels
            render 'history'
        end
    end

    def booked
        if current_user == nil
            redirect_to root_path
        else
            if current_user.role == 'driver'
                @travels = current_user.driving_travels.future
                @tickets = []
                @ticket = Ticket.new
            else
                @travels = current_user.travels.pending
                @tickets = Ticket.where(user: current_user)
            end
        end
    end

	def show
		@travel = Travel.find(params[:id])
		@duration = calculate_duration(@travel.date_departure, @travel.date_arrival)
        @comments = @travel.comments
        @ticket = Ticket.find_by(travel: @travel, user: current_user)
        if @ticket == nil
            @ticket = Ticket.new
        end
	end

    def next
        @ticket = Ticket.new
        @travel = current_user.driving_travels.future.first
    end

    def step_new
		if current_user == nil || current_user.role != "admin"
			redirect_to root_path
		end
		@travel = Travel.new
    end

	def new
		if current_user == nil || current_user.role != "admin"
			redirect_to root_path
		end
		
    	@travel = Travel.new(params.require(:travel).permit(:route_id, :capacity, :price, :discount, :date_departure, :date_arrival))
		if validate_fields(@travel.price, @travel.discount, @travel.date_departure, @travel.date_arrival)
        	@drivers = User.where(role: "driver")
        	@validDrivers = []
        	@drivers.each do |driver|
        		@valid = true
        		driver.driving_travels.each do |t|
        			if (t.id != @travel.id)
        				if !(t.date_arrival < @travel.date_departure || t.date_departure > @travel.date_arrival)
        					@valid = false
        					break
        				end
        			end
        		end
        		if (@valid)
        				@validDrivers.push(driver)
        		end
        	end


        	@combis = Combi.all
        	@validCombis = []
        	@combis.each do |combi|
        		@valid = true
        		combi.travels.each do |t|
        			if (t.id != @travel.id)
          				if !(t.date_arrival < @travel.date_departure || t.date_departure > @travel.date_arrival)
        					@valid = false
        					break
        				end
        			end
        		end
        		if @valid
        			@validCombis.push(combi)
        		end
        	end
        else
            render 'step_new'
        end
    end

    def create
		@travel = Travel.create(params.require(:travel).permit(:route_id, :capacity, :price, :discount,:date_departure, :date_arrival, :combi_id, :driver_id))
        if @travel.save
            flash[:success] = "El viaje " + @travel.name + " ha sido creado con éxito!"
            redirect_to travels_path
        else
            flash[:form_error] = "Algo salió mal."
            render 'step_new'
        end
    end

	def step_edit
		if current_user == nil || current_user.role != "admin"
			redirect_to root_path
		end
		@travel = Travel.find(params[:id])
		@selectedDriver = User.where(id: @travel.driver.id)
		@selectedCombi = Combi.where(id: @travel.combi.id)
    end

	def edit
		if current_user == nil || current_user.role != "admin"
			redirect_to root_path
		end
    	@travel = Travel.find(params[:id])
       	@travel.attributes = params.require(:travel).permit(:route_id, :capacity, :price, :discount, :date_departure, :date_arrival, :combi_id, :driver_id)
		if validate_fields(@travel.price, @travel.discount ,@travel.date_departure, @travel.date_arrival)
            @selectedRoute = Route.where(id: @travel.route.id)
    	    @drivers = User.where(role: "driver")
        	@validDrivers = []
        	@drivers.each do |driver|
        		@valid = true
        		driver.driving_travels.each do |t|
        			if (t.id != @travel.id)
        				if !(t.date_arrival < @travel.date_departure || t.date_departure > @travel.date_arrival)
        					@valid = false
        					break
        				end
        			end
        		end
        		if (@valid)
        				@validDrivers.push(driver)
        		end
        	end

        	@combis = Combi.all
        	@validCombis = []
        	@combis.each do |combi|
        		@valid = true
        		combi.travels.each do |t|
        			if (t.id != @travel.id)
    	      			if !(t.date_arrival < @travel.date_departure || t.date_departure > @travel.date_arrival)
    	    				@valid = false
    	    				break
    	    			end
    	    		end
        		end
        		if @valid
        			@validCombis.push(combi)
        		end
        	end
        else
            @selectedDriver = User.where(id: @travel.driver.id)
            @selectedCombi = Combi.where(id: @travel.combi.id)
            render 'step_edit'
        end
    end

    def update
    	@travel = Travel.find(params[:id])
        @travel.attributes = params.require(:travel).permit(:route_id, :capacity, :price, :discount, :date_departure, :date_arrival, :combi_id, :driver_id)
        if @travel.save
            flash[:success] = "El viaje " + @travel.name + " ha sido actualizado con éxito!"
            redirect_to travels_path
        else
            flash[:form_error] = "Algo salió mal."
            render 'step_edit'
        end
    end

    def destroy
    	@travel = Travel.find(params[:id])
        if @travel.destroy
            flash[:success] = "El viaje " + @travel.name + " ha sido borrado con éxito"
            redirect_to travels_path
        else
            flash[:index_error] = 'Algo salió mal'
            redirect_to travels_path
        end
	end
	
	def validate_fields(price, discount, date_departure, date_arrival)
        errors = []
        if date_departure == nil || date_arrival == nil || date_departure > date_arrival || date_departure < DateTime.current.beginning_of_day || date_arrival < DateTime.current.beginning_of_day
            errors << "Las fechas ingresadas son inválidas. "
        end
        if price < 0
            errors << "El precio debe ser mayor o igual a 0."
		end
		if discount < 0 || discount > 100
			errors << "El porcentaje de descuento debe estar entre 0 y 100."
		end
        if errors != []
            flash[:form_error] = errors
            return false
        else
            return true
        end
    end

    def calculate_duration(departure, arrival)
        duration_hours = ((arrival.to_time - departure.to_time) / 1.hour).floor
        duration_minutes = (((arrival.to_time - departure.to_time) / 1.minute).round) - (duration_hours * 60)
        duration = [duration_hours, duration_minutes]
        return duration
    end

end