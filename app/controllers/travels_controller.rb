class TravelsController < ApplicationController
	def index
        @ticket = Ticket.new
		if current_user != nil && current_user.role == "admin"
            @travels = Travel.pending
        else
            @travels = Travel.future
        end
        if current_user == nil || current_user.role != "driver"
            @searchedTravels = @travels
            if params[:search] && params[:search][:route_id] != ""
                @searchedTravels = @searchedTravels.where({route_id: params[:search][:route_id]})
            end
            if params[:date_search] && !params[:dont_know_date]
                @date = params[:date_search].to_date
                @searchedTravels = @searchedTravels.where(date_departure: @date.all_day)
            end
            if current_user != nil
                if current_user.role == "admin"
                    if params[:recurrence] && params[:recurrence] != ""
                        @travels = @searchedTravels.where(recurrence_name: params[:recurrence].downcase)
                    else
                        @travels = @searchedTravels
                    end
                else
                    @travels = []
                    @searchedTravels.each do |travel|
                        if !current_user.travels.include?travel
                            @travels.push(travel)
                        end
                    end
                end
            else
                @travels = @searchedTravels
            end
            if current_user == nil || current_user.role == "user"
                render 'clients_index'
            end
        else
            redirect_to booked_travels_path
        end
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
                @travels = current_user.travels.future
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

    def current
        @ticket = Ticket.new
        @travel = current_user.driving_travels.current.first
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
		
    	@travel = Travel.new(params.require(:travel).permit(:route_id, :price, :discount, :date_departure, :date_arrival, :recurrence, :recurrence_name))
        if !@travel.recurrent
            @travel.recurrence_name = nil
        end
		if validate_fields(true, @travel.price, @travel.discount, @travel.date_departure, @travel.date_arrival, @travel.recurrence, @travel.recurrence_name, params[:end_date])
        	@validDrivers = []
        	User.drivers.each do |driver|
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


        	@validCombis = []
        	Combi.all.each do |combi|
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
		@travel = Travel.create(params.require(:travel).permit(:route_id, :price, :discount,:date_departure, :date_arrival, :combi_id, :driver_id, :recurrence, :recurrence_name))
        flash[:form_error] = []
        if @travel.save
            if @travel.recurrent
                if create_recurrent_travels(params[:end_date], @travel.driver)
                    flash[:success] = "El viaje " + @travel.name + " y los asociados con la recurrencia: '" + @travel.recurrence_type + "' han sido creados con éxito!"
                    redirect_to travels_path
                else
                    if flash[:form_error] == []
                        flash[:form_error] << "No se pudieron crear los viajes porque el chofer o la combi estan ocupados en alguna de las fechas recurrentes"
                    end
                    Travel.where(recurrence_name: @travel.recurrence_name).each do |t|
                        if t.id != @travel.id
                            t.destroy
                        end
                    end
                    @travel.destroy
                    render 'step_new'
                end
            else
                flash[:success] = "El viaje " + @travel.name + " ha sido creado con éxito!"
                redirect_to travels_path
            end
        else
            flash[:form_error] << "Algo salió mal."
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
       	@travel.attributes = params.require(:travel).permit(:route_id, :price, :discount, :date_departure, :date_arrival, :combi_id, :driver_id)
		if validate_fields(false, @travel.price, @travel.discount ,@travel.date_departure, @travel.date_arrival, @travel.recurrence.downcase, nil, DateTime.now + 1.days)
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
        @travel.attributes = params.require(:travel).permit(:route_id, :price, :discount, :date_departure, :date_arrival, :combi_id, :driver_id)
        if params[:delete_recurrence]
            delete_recurrence
        end
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
        @travels = []
        @travels.push(@travel)
        tickets = @travel.tickets.count
        @travel.tickets.each do |ticket|
            TravelMailer.refund_mail(ticket.user, @travels, 100, ticket.price).deliver_later
        end
        if @travel.destroy
            if current_user.role == "admin"
                deleted = "borrado"
            else
                deleted = "cancelado"
            end
            flash[:successes] = []
            flash[:successes] << "El viaje " + @travel.name + " ha sido " + deleted + " con éxito"
            if tickets > 0
                refund = '100%'
                flash[:successes] << "Se reintegró el " + refund + " del pago a todos los pasajeros del viaje"
            end
        else
            flash[:index_error] = 'Algo salió mal'
        end
        redirect_to root_path
	end

    def destroy_recurrents
        @travel = Travel.find(params[:id])
        recurrent = @travel.recurrent
        @recurrence_name = @travel.recurrence_name
        if @travel.destroy
            if recurrent
                if destroy_recurrent_travels
                    flash[:successes] = []
                    flash[:successes] << "El viaje " + @travel.name + " y los asociados con la recurrencia: '" + @travel.recurrence_type + "' han sido borrados con éxito!"
                    refund = '100%'
                    flash[:successes] << "Se reintegró el " + refund + " del pago a todos los pasajeros del viaje"
                else
                    flash[:index_error] = 'Algo salió mal'
                end
            else
                flash[:success] = "El viaje " + @travel.name + " ha sido borrado con éxito"
            end
        else
            flash[:index_error] = 'Algo salió mal'
        end
        redirect_to travels_path
    end
	
	def validate_fields(create, price, discount, date_departure, date_arrival, recurrence, recurrence_name, end_date)
        errors = []
        if date_departure == nil || date_arrival == nil || date_departure > date_arrival || date_departure < DateTime.now
            errors << "Las fechas ingresadas son inválidas. "
        end
        if price < 0
            errors << "El precio debe ser mayor o igual a 0."
		end
		if discount < 0 || discount > 100
			errors << "El porcentaje de descuento debe estar entre 0 y 100."
		end
        if create && recurrence != "none_"
            if recurrence_name == ""
                errors << "Debe establecer un nombre para la recurrencia"
            else
                t = Travel.find_by(recurrence_name: recurrence_name)
                if t
                    errors << "El nombre de la recurrencia debe ser único para este grupo de viajes"
                end
            end
            if end_date == nil || end_date < DateTime.current.beginning_of_day
                errors << "La fecha de finalización de recurrencia es inválida, debe ser posterior a la actual"
            end
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

    def create_recurrent_travels(end_date, driver)
        departure = @travel.date_departure
        arrival = @travel.date_arrival
        driving_travels = driver.driving_travels.pending
        case @travel.recurrence.to_sym
        when :half_day
            time = 12.hours
        when :day
            time = 1.days
        when :week
            time = 7.days
        when :half_month
            time = 15.days
        when :month
            time = 1.months
        when :twice_month
            time = 2.months
        when :half_year
            time = 6.months
        end
        departure = departure + time
        arival = arrival + time
        if end_date > DateTime.now + 1.years
            end_date = DateTime.now + 1.years
        end
        while departure < end_date
            t = Travel.create(route: @travel.route, price: @travel.price, discount: @travel.discount, date_departure: departure, date_arrival: arrival, combi: @travel.combi, driver: @travel.driver, recurrence: @travel.recurrence, recurrence_name: @travel.recurrence_name)
            driving_travels.each do |dt|
                if !(dt.date_arrival < t.date_departure || dt.date_departure > t.date_arrival)
                    return false
                end
            end
            if !t.save
                flash[:form_error] = []
                flash[:form_error] << "Algo salió mal"
                return false
            end
            departure = departure + time
            arrival = arrival + time
        end
        return true
    end

    def destroy_recurrent_travels
        travels = Travel.future.where(recurrence_name: @recurrence_name.downcase)
        travels.each do |t|
            if !t.destroy
                return false
            end
        end
        return true
    end

    def delete_recurrence
        @travel.update(recurrence_name: nil, recurrence: :none_)
    end

end