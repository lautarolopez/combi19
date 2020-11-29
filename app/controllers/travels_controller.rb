class TravelsController < ApplicationController
	def index
		@travels = Travel.all
		if current_user == nil || current_user.role == "user"
			render 'clients_index'
		end
	end

    def index_history
        if current_user == nil
            redirect_to root_path
        else
            @travels = []
            Travel.all.each do |travel|
                if (travel.passengers.include?current_user) && (travel.date_arrival < DateTime.now)
                    @travels << travel
                end
            end
        end
    end

	def show
		@travel = Travel.find(params[:id])
		@duration = calculate_duration(@travel.date_departure, @travel.date_arrival)
	end

    def book
        @travel = Travel.find(params[:id])
        @duration = calculate_duration(@travel.date_departure, @travel.date_arrival)
        if current_user == nil
            flash[:warning] = "Debe estar registrado para comprar pasajes"
            redirect_to travels_path
        else
            if current_user.discharge_date != nil && current_user.discharge_date > @travel.date_departure
                flash[:error] = 'No puede reservar este viaje porque presenta síntomas de covid'
            end
        end
    end

    def pay
        @travel = Travel.find(params[:travel_id])
        @method = params[:method]
        @payment_method = nil
        if @method == 'existing'
            if params[:payment_method]
                @payment_method = PaymentMethod.find_by(id: params[:payment_method][:id])
            end
        else
            @payment_method = PaymentMethod.create(card_number: params[:card_number], name: params[:name], expire_month: params[:date][:month], expire_year: params[:date][:year], verification_code: params[:verification_code], company: params[:company], user_id: current_user.id)
            if !@payment_method.save
                flash[:form_error] = @payment_method.errors.full_messages
                render 'book'
            end
        end

        if @payment_method == nil
            flash[:form_error] = []
            flash[:form_error] << 'Debe seleccionar un método de pago'
            render 'book'
        else
            if @payment_method.save
                if validate_card(@payment_method, @method, params[:verification_code])
                    if @method == 'new'
                        @payment_method.destroy
                    end
                    if !params[:covid]
                        current_user.update(discharge_date: Date.today + 15.days)
                        if current_user.discharge_date < @travel.date_departure
                            @travel.passengers << current_user
                            flash[:success] = 'Ha reservado el viaje ' + @travel.id.to_s + ' con éxito!'
                            redirect_to travel_path(@travel)
                        else
                            flash[:error] = 'No puede reservar este viaje porque presenta síntomas de covid'
                            redirect_to travel_path(@travel)
                        end
                    else
                        current_user.update(discharge_date: nil)
                        @travel.passengers << current_user
                        flash[:success] = 'Ha reservado el viaje ' + @travel.id.to_s + ' con éxito!'
                        redirect_to travel_path(@travel)
                    end
                else
                    if @method == 'new'
                        @payment_method.destroy
                    end
                    render 'book'
                end
            end
        end
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

    def calculate_duration(departure, arrival)
        duration_hours = ((arrival.to_time - departure.to_time) / 1.hour).floor
        duration_minutes = (((arrival.to_time - departure.to_time) / 1.minute).round) - (duration_hours * 60)
        duration = [duration_hours, duration_minutes]
        return duration
    end

    def validate_card(card, method, code)
        #if card_number.to_s.match ^3[47][0-9]{13}$
        valid = true
        flash[:form_error] = []
        number = card.card_number.to_s
        if method == 'new'
            if number.length < 14 || number.length > 19
                flash[:form_error] << 'El número de la tarjeta es inválido:'
                flash[:form_error] << 'Debe contener entre 14 y 19 dígitos'
                valid = false
            end
            if number[0] < '3' || number[0] > '5'
                if flash[:form_error] == []
                    flash[:form_error] << 'El número de la tarjeta es inválido:'
                end
                flash[:form_error] << 'Debe comenzar en 3, 4 o 5'
                valid = false
            end
        else
            if card == nil 
                flash[:form_error] << 'card nil'
            else
                flash[:form_error] << card.id
                flash[:form_error] << card.card_number
                if card.expire_year < Date.today.year || (card.expire_year == Date.today.year && card.expire_month < Date.today.month)
                    flash[:form_error] << 'La fecha de expiración es inválida. Le aconsejamos corregir o eliminar el método de pago'
                    valid = false
                end
                if card.verification_code != code
                    flash[:form_error] << 'El código de verificacón es incorrecto'
                    valid = false
                end
            end
        end
        if flash[:form_error] == []
            if number[number.length-1] == '9'
                flash[:form_error] << 'El método de pago no tiene fondos suficientes'
                valid = false
            end
        end
        if valid
            return true
        else
            return false
        end
    end

end