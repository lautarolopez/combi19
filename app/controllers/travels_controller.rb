class TravelsController < ApplicationController
	def index
		if current_user != nil && current_user.role == "admin"
            @travels = Travel.pending
        else
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
            
        end
        render 'clients_index'
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
            @travels = current_user.travels.previous
        end
    end

    def booked
        if current_user == nil
            redirect_to root_path
        else
            @travels = current_user.travels.pending
        end
    end

	def show
		@travel = Travel.find(params[:id])
		@duration = calculate_duration(@travel.date_departure, @travel.date_arrival)
        @comments = @travel.comments
	end

    def book
        @travel = Travel.find(params[:id])
        @duration = calculate_duration(@travel.date_departure, @travel.date_arrival)
        if current_user == nil
            flash[:warning] = "Debes estar registrado para comprar pasajes"
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
        @paymentMethod = nil
        if @method == 'existing'
            if params[:payment_method][:id] != ''
                @paymentMethod = PaymentMethod.find_by(id: params[:payment_method][:id])
            else
                flash[:form_error] = []
                flash[:form_error] << 'Debe seleccionar un método de pago'
                render 'book'
            end
        else
            @paymentMethod = PaymentMethod.new(card_number: params[:card_number], name: params[:name], expire_month: params[:date][:month], expire_year: params[:date][:year], verification_code: params[:verification_code], company: params[:company], user_id: current_user.id)
        end

        if @paymentMethod != nil
            if @method == 'existing' || (@method == 'new' && @paymentMethod.save)
                if validate_card(@paymentMethod, @method, params[:verification_code])
                    if params[:not_covid]
                        current_user.update(discharge_date: nil)
                    else
                        current_user.update(discharge_date: Date.today + 15.days)
                        travel_ids = []
                        current_user.travels.where("date_departure < ?", current_user.discharge_date).each do |t|
                            current_user.travels.delete(t)
                            t.update(occupied: t.occupied - 1)
                            travel_ids << t.id
                        end
                        if travel_ids != []
                            flash[:warning] = "Como declaraste que presentás síntomas de covid se canceló la reserva que tenías de " + travel_ids.count.to_s + " viaje/s con fechas dentro de los próximos 15 días"#. Se envió por correo el resumen detallado de el/los mismo/s"
                        end
                    end
                    if current_user.discharge_date != nil && current_user.discharge_date > @travel.date_departure
                        if @method == 'new'
                            @paymentMethod.destroy
                        end
                        flash[:error] = "No podes reservar un pasaje para este viaje porque presentas síntomas de covid"
                        redirect_to travel_path(@travel)
                    else
                        @travel.update(occupied: @travel.occupied + 1)
                        @travel.passengers << current_user
                        flash[:success] = []
                        flash[:success] << "Has reservado el viaje " + @travel.name + " con éxito!"
                        if @method == 'new' && params[:save_new]
                            flash[:success] << 'El método de pago ' + @paymentMethod.card + ' se registró exitosamente en su cuenta'
                        end
                        redirect_to travel_path(@travel)
                    end
                else
                    render 'book'
                end
                if @paymentMethod != nil && @method == 'new' && !params[:save_new]
                    @paymentMethod.destroy
                end
            else
                if @paymentMethod.errors
                    flash[:form_error] = @paymentMethod.errors.full_messages
                else
                    flash[:form_error] = []
                    flash[:form_error] << "Algo salió mal"
                end
                render 'book'
            end
        end
    end
	
    def cancel
        if current_user != nil
            @travel = Travel.find(params[:id])
            @travel.passengers.delete(current_user)
            @travel.update(occupied: @travel.occupied)
            flash[:success] = []
            flash[:success] << "Se canceló su reserva para el viaje " + @travel.name
            if @travel.date_departure > (DateTime.now + 48.hours)
                refund = 100.to_s + '%'
            else
                refund = 50.to_s + '%'
            end
            flash[:success] << "Se reintegró el " + refund + " del pago en el método de pago utilizado"
        else
            flash[:fom_error] = 'Algo salió mal'
        end
        redirect_to travel_path(@travel)
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

    def validate_card(card, method, code)
        #if card_number.to_s.match ^3[47][0-9]{13}$
        valid = true
        flash[:form_error] = []
        number = card.card_number.to_s
        if method == 'existing'
            if card.expire_year < Date.today.year || (card.expire_year == Date.today.year && card.expire_month < Date.today.month)
                flash[:form_error] << 'La fecha de expiración es inválida, por favor eliminá el método de pago'
                valid = false
            end
            if card.verification_code != code.to_i
                flash[:form_error] << 'El código de verificación es incorrecto'
                valid = false
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