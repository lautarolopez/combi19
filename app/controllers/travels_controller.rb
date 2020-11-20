class TravelsController < ApplicationController
	def index
        @travels = Travel.all
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
		
    	@travel = Travel.new(params.require(:travel).permit(:route_id, :capacity, :price, :date_departure, :date_arrival))
		if validate_fields(@travel.capacity, @travel.price, @travel.date_departure, @travel.date_arrival)
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
		@travel = Travel.create(params.require(:travel).permit(:route_id, :capacity, :price, :date_departure, :date_arrival, :combi_id, :driver_id))
        if @travel.save
            flash[:success] = "El viaje " + @travel.route.origin.name.titleize + ", " + @travel.route.origin.state.titleize + " - " + @travel.route.destination.name.titleize + ", " + @travel.route.destination.state.titleize + " el día " + @travel.date_departure.strftime('%m/%d/%Y') + " a las " + @travel.date_departure.strftime('%H:%M') + " hs. ha sido creado con éxito!"
            redirect_to travels_path
        else
            # from here
            if (@travel.errors.messages != nil)
                flash[:error] = @travel.errors[:date_departure]
                if @travel.errors[:capacity]
                    flash[:error] << "La capacidad debe ser mayor a 0. "
                end
                if @travel.errors[:price]
                    flash[:error] << "El precio debe ser un valor positivo. "
                end
            else 
            # to here: I think it's unnecessary code
                flash[:error] = "Algo salió mal."
            end
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
       	@travel.attributes = params.require(:travel).permit(:route_id, :capacity, :price, :date_departure, :date_arrival, :combi_id, :driver_id)
		if validate_fields(@travel.capacity, @travel.price, @travel.date_departure, @travel.date_arrival)
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
        @travel.attributes = params.require(:travel).permit(:route_id, :capacity, :price, :date_departure, :date_arrival, :combi_id, :driver_id)
        if @travel.save
            flash[:success] = "El viaje " + @travel.route.origin.name.titleize + ", " + @travel.route.origin.state.titleize + " - " + @travel.route.destination.name.titleize + ", " + @travel.route.destination.state.titleize + " el día " + @travel.date_departure.strftime('%m/%d/%Y') + " a las " + @travel.date_departure.strftime('%H:%M') + " hs. ha sido actualizado con éxito!"
            redirect_to travels_path
        else
            # from here
            if (@travel.errors.messages != nil)
                flash[:error] = @travel.errors[:date_departure]
                if @travel.errors[:capacity]
                    flash[:error] << "La capacidad debe ser mayor a 0. "
                end
                if @travel.errors[:price]
                    flash[:error] << "El precio debe ser un valor positivo. "
                end
            else 
            # to here: I think it's unnecessary code
                flash[:error] = "Algo salió mal."
            end
            render 'step_edit'
        end
    end

    def destroy
    	@travel = Travel.find(params[:id])
        if @travel.destroy
            flash[:success] = "El viaje " + @travel.route.origin.name.titleize + ", " + @travel.route.origin.state.titleize + " - " + @travel.route.destination.name.titleize + ", " + @travel.route.destination.state.titleize + " del día " + @travel.date_departure.strftime('%m/%d/%Y') + " a las " + @travel.date_departure.strftime('%H:%M') + " hs. ha sido borrado con éxito"
            redirect_to travels_path
        else
            flash[:error] = 'Algo salió mal'
            redirect_to travels_path
        end
	end
	
	def validate_fields(capacity, price, date_departure, date_arrival)
        errors = []
        if date_departure == nil || date_arrival == nil || date_departure > date_arrival || date_departure < DateTime.current.beginning_of_day || date_arrival < DateTime.current.beginning_of_day
            errors << "Las fechas ingresadas son inválidas. "
        end
        if capacity <= 0
            errors << "La capacidad debe ser mayor a 0. "
        end
        if price < 0
            errors << "El precio debe ser un valor positivo."
        end
        if errors != []
            flash[:error] = ""
            errors.each do |e|
                flash[:error] << e
            end
            return false
        else
            return true
        end
    end
end
