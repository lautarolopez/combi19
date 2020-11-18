class TravelsController < ApplicationController
	def index
        @travels = Travel.all
    end

    def step_new
    	@travel = Travel.new
    end

    def new
    	@travel = Travel.new(params.require(:travel).permit(:route_id, :capacity, :price, :date_departure, :date_arrival))

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
    end

    def create
		@travel = Travel.create(params.require(:travel).permit(:route_id, :capacity, :price, :date_departure, :date_arrival, :combi_id, :driver_id))
        if @travel.save
            flash[:success] = "El viaje " + @travel.route.origin.name.titleize + ", " + @travel.route.origin.state.titleize + " - " + @travel.route.destination.name.titleize + ", " + @travel.route.destination.state.titleize + " del día " + @travel.date_departure.strftime('%m/%d/%Y') + " a las " + @travel.date_departure.strftime('%I:%M %p') + " ha sido creado con éxito!"
            redirect_to travels_path
        else
        	if (@travel.errors.messages != nil)
        		flash[:error] = @travel.errors[:date_departure]
            else 
            	flash[:error] = "Algo salió mal."
            end
            render 'step_new'
        end
    end

    def step_edit
    	@travel = Travel.find(params[:id])
    end

    def edit
    	@travel = Travel.find(params[:id])
       	@travel.attributes = params.require(:travel).permit(:route_id, :capacity, :price, :date_departure, :date_arrival, :combi_id, :driver_id)
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
    end

    def update
    	@travel = Travel.find(params[:id])
        if @travel.update(params.require(:travel).permit(:route_id, :capacity, :price, :date_departure, :date_arrival, :combi_id, :driver_id))
            flash[:success] = "El viaje " + @travel.route.origin.name.titleize + ", " + @travel.route.origin.state.titleize + " - " + @travel.route.destination.name.titleize + ", " + @travel.route.destination.state.titleize + " del día " + @travel.date_departure.strftime('%m/%d/%Y') + " a las " + @travel.date_departure.strftime('%I:%M %p') + " ha sido actualizado con éxito!"
            redirect_to travels_path
        else
            if (@travel.errors.messages != nil)
        		flash[:error] = @travel.errors[:date_departure]
            else 
            	flash[:error] = "Algo salió mal."
            end
            render 'step_edit'
        end
    end

    def destroy
    	@travel = Travel.find(params[:id])
        if @travel.destroy
            flash[:success] = "El viaje " + @travel.route.origin.name.titleize + ", " + @travel.route.origin.state.titleize + " - " + @travel.route.destination.name.titleize + ", " + @travel.route.destination.state.titleize + " del día " + @travel.date_departure.strftime('%m/%d/%Y') + " a las " + @travel.date_departure.strftime('%I:%M %p') + " ha sido borrado con éxito"
            redirect_to travels_path
        else
            flash[:error] = 'Algo salió mal'
            redirect_to travels_path
        end
    end
end
