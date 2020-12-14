class TicketsController < ApplicationController
	def book
        @travel = Travel.find(params[:id])
        if current_user == nil
            flash[:warning] = "Debes estar registrado para comprar pasajes"
            redirect_to travel_path(@travel)
        else
            if current_user.discharge_date != nil && current_user.discharge_date > @travel.date_departure
                flash[:error] = 'No puede reservar este viaje porque presenta síntomas de covid'
                redirect_to travel_path(@travel)
            else
            	@ticket = Ticket.new(params.require(:ticket).permit(extra_ids: []))
            	@ticket.attributes = {user: current_user, travel: @travel}
            	@ticket.price = sum_price(current_user, @travel)
            end
        end
    end

    def create
        @travel = Travel.find(params[:ticket][:travel_id])
        @ticket = Ticket.new(params.require(:ticket).permit(:travel_id, :user_id, :price, extra_ids: []))
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
                	@ticket.attributes = {payment_method: @paymentMethod.card}
                	if @ticket.save
	                    if params[:not_covid]
	                        current_user.update(discharge_date: nil)
	                    else
	                        current_user.update(discharge_date: Date.today + 15.days)
	                        @travel_ids = []
	                        if cancel_bookings
	                            flash[:warning] = "Como declaraste que presentás síntomas de covid se canceló la reserva que tenías de " + @travel_ids.size.to_s + " viaje" + s + " con fechas dentro de los próximos 15 días. Se envió por correo el resumen detallado del reintegro"
	                        end
	                    end
	                    if current_user.discharge_date != nil && current_user.discharge_date > @travel.date_departure
	                        if @method == 'new'
	                            @paymentMethod.destroy
	                        end
	                        @ticket.destroy
	                        flash[:error] = "No podes reservar un pasaje para este viaje porque presentas síntomas de covid"
	                        redirect_to travel_path(@travel)
	                    else
                            flash[:success] = []
                            flash[:success] << "Has reservado el viaje " + @travel.name + " con éxito!"
                            if @method == 'new' && params[:save_new]
                                flash[:success] << 'El método de pago ' + @paymentMethod.card + ' se registró exitosamente en su cuenta'
                            end
                            redirect_to travel_path(@travel)
	                    end
	                else
	                	flash[:form_error] = []
                        flash[:form_error] << "Algo salió mal"
                        render 'book'
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

    def passenger
    	@ticket = Ticket.find(params[:id])
    	@passenger = @ticket.user
    end

    def absent
    	@ticket = Ticket.find(params[:id])
    	@ticket.status = :absent
    	if @ticket.save
    		flash[:success] = "Se registró que el pasajero no se presentó al viaje"
    	else
    		flash[:error] = "Algo salió mal"
		end
		redirect_to root_path
    end

    def resolve
    	@ticket = Ticket.find(params[:id])
    	@temp = params[:temp]
    	@strong = params[:strong_synthoms]
    	@medium = params[:medium_synthoms]
    	@same = params[:same_synthoms]

    	if confirm(@temp, @strong, @medium, @same)
    		@ticket.update(status: :confirmed)
    		flash[:success] = "Se registró el pasajero en el viaje"
    	else
    		@ticket.update(status: :rejected)
    		@passenger = @ticket.user
    		@passenger.update(discharge_date: DateTime.now + 15.days)
            flash[:error] = "El pasajero no puede viajar porque presenta síntomas compatibles de covid"
            @travel_ids = []
            if cancel_bookings
            	flash[:warning] = "Se canceló la reserva que tenía de " + travel_ids.size.to_s + " viaje" + s + " con fechas dentro de los próximos 15 días. Se le envió por correo el resumen detallado del reintegro"
            end
    	end
    	#redirect_to root_path
    	render 'prueba'
    end
	
    def destroy
        if current_user != nil
        	@ticket = Ticket.find(params[:id])
            @travel = @ticket.travel
            money = @ticket.price
            @ticket.destroy
            flash[:success] = []
            flash[:success] << "Se canceló su reserva para el viaje " + @travel.name
            if @travel.date_departure > (DateTime.now + 48.hours)
                refund = 100.to_s + '% ($' + money.to_s + ')'
            else
                refund = 50.to_s + '% ($' + (money*0.5).to_s + ')'
            end
            flash[:success] << "Se reintegró el " + refund + " del pago en el método de pago utilizado"
        else
            flash[:fom_error] = 'Algo salió mal'
        end
        redirect_to travel_path(@travel)
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

    def sum_price(user, travel)
        if user.subscribed
            price = travel.price *  (1 - travel.discount/100.0)
        else
            price = travel.price
        end
        @ticket.extras.each do |extra|
        	price = price + extra.price
        end
        return price
    end

    def confirm(temp, strong, medium, same)
    	if strong
    		return false
    	else
    		if medium
    			if medium.size > 1
    				return false
    			else
    				if same || (temp > "37.4")
	    				return false
	    			end
    			end
    		else
    			if same && (temp > "37.4")
    				return false
    			end
    		end
    	end
    	return true
    end

    def cancel_bookings
    	tick = nil
        @passenger.travels.where("date_departure < ?", @passenger.discharge_date).each do |t|
            tick = Ticket.find_by(travel: t, user: @passenger)
            if tick != nil && tick != @ticket
                tick.destroy
                #Agregar viaje a la lista del mail
                @travel_ids.push(t)
            end
        end
		if @travel_ids.size > 0
			if @travel_ids.size > 1
                s = "s"
            else
                s = ""
            end
            return true
        else
        	return false
        end
    end
end
