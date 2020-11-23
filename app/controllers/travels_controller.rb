class TravelsController < ApplicationController
	def index
		@travels = Travel.all
		if current_user == nil || current_user.role == "user"
			render 'clients_index'
		end
	end

	def show
		@travel = Travel.find(params[:id])
		@duration = calculate_duration(@travel.date_departure, @travel.date_arrival)
	end

	def calculate_duration(departure, arrival)
		duration_hours = ((arrival.to_time - departure.to_time) / 1.hour).floor
		duration_minutes = (((arrival.to_time - departure.to_time) / 1.minute).round) - (duration_hours * 60)
		duration = [duration_hours, duration_minutes]
		return duration
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
            flash[:success] = "El viaje " + @travel.route.origin.name.titleize + ", " + @travel.route.origin.state.titleize + " - " + @travel.route.destination.name.titleize + ", " + @travel.route.destination.state.titleize + " el día " + @travel.date_departure.strftime('%m/%d/%Y') + " a las " + @travel.date_departure.strftime('%H:%M') + " hs. ha sido creado con éxito!"
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
            flash[:success] = "El viaje " + @travel.route.origin.name.titleize + ", " + @travel.route.origin.state.titleize + " - " + @travel.route.destination.name.titleize + ", " + @travel.route.destination.state.titleize + " el día " + @travel.date_departure.strftime('%m/%d/%Y') + " a las " + @travel.date_departure.strftime('%H:%M') + " hs. ha sido actualizado con éxito!"
            redirect_to travels_path
        else
            flash[:form_error] = "Algo salió mal."
            render 'step_edit'
        end
    end

    def destroy
    	@travel = Travel.find(params[:id])
        if @travel.destroy
            flash[:success] = "El viaje " + @travel.route.origin.name.titleize + ", " + @travel.route.origin.state.titleize + " - " + @travel.route.destination.name.titleize + ", " + @travel.route.destination.state.titleize + " del día " + @travel.date_departure.strftime('%m/%d/%Y') + " a las " + @travel.date_departure.strftime('%H:%M') + " hs. ha sido borrado con éxito"
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
end
