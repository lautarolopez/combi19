class PaymentMethodsController < ApplicationController
  def index
    if current_user == nil
      redirect_to root_path
    end
    @paymentMethods = PaymentMethod.where(user: current_user)
  end

  def new
    if current_user == nil
      redirect_to root_path
    end
    @paymentMethod = PaymentMethod.new
    monthNames = I18n.t('date.month_names')[1..12]
    @months = Array.new(12) {Array.new(2)}
    for i in 0..11
      @months[i][0] = monthNames[i]
      @months[i][1] = i+1
    end
    @today = [monthNames[Date.today.month-1], Date.today.month]
  end

  def create
    monthNames = I18n.t('date.month_names')[1..12]
    @months = Array.new(12) {Array.new(2)}
    for i in 0..11
      @months[i][0] = monthNames[i]
      @months[i][1] = i+1
    end
    @today = [monthNames[Date.today.month-1], Date.today.month]
    @paymentMethod = PaymentMethod.new(params.require(:payment_method).permit(:card_number, :name, :expire_month, :expire_year, :verification_code, :company, :combi_id))
    @paymentMethod.attributes = {user_id: current_user.id}
    if @paymentMethod.save
      flash[:success] =  "El método de pago " + @paymentMethod.card + " ha sido creado con éxito!"
      redirect_to payment_methods_path
    else
      if @paymentMethod.errors
        flash[:form_error] = @paymentMethod.errors.full_messages
        if flash[:form_error][0].include?'uso'
          flash[:form_error] = []
          @aux = PaymentMethod.find_by(card_number: @paymentMethod.card_number)
          if @aux != nil
            flash[:form_error] << "Ya existe un método de pago con el número " + @paymentMethod.encrypted_number
          else 
            flash[:form_error] << "Algo salió mal."
          end
        else 
          if flash[:form_error] == []
            flash[:form_error] << "Algo salió mal."
          end
        end
      end
      render 'new'
    end
  end

  def edit
    if current_user == nil
      redirect_to root_path
    end
    @paymentMethod = PaymentMethod.find(params[:id])
    monthNames = I18n.t('date.month_names')[1..12]
    @months = Array.new(12) {Array.new(2)}
    for i in 0..11
      @months[i][0] = monthNames[i]
      @months[i][1] = i+1
    end
    @today = [monthNames[Date.today.month-1], Date.today.month]
  end

  def update
    monthNames = I18n.t('date.month_names')[1..12]
    @months = Array.new(12) {Array.new(2)}
    for i in 0..11
      @months[i][0] = monthNames[i]
      @months[i][1] = i+1
    end
    @today = [monthNames[Date.today.month-1], Date.today.month]
    @paymentMethod = PaymentMethod.find(params[:id])
    @paymentMethod.attributes = params.require(:payment_method).permit(:card_number, :name, :expire_month, :expire_year, :verification_code, :company, :combi_id)
    @paymentMethod.attributes = {user_id: current_user.id}
    if @paymentMethod.save
      flash[:success] =  "El método de pago " + @paymentMethod.card + " ha sido actualizado con éxito!"
      redirect_to payment_methods_path
    else
      if @paymentMethod.errors
        flash[:form_error] = @paymentMethod.errors.full_messages
        if flash[:form_error][0].include?'uso'
          flash[:form_error] = []
          @aux = PaymentMethod.find_by(card_number: @paymentMethod.card_number)
          if @aux != nil
            flash[:form_error] << "Ya existe un método de pago con el número " + @paymentMethod.encrypted_number
          else 
            flash[:form_error] << "Algo salió mal."
          end
        else 
          flash[:form_error] << "Algo salió mal."
        end
      end
      render 'edit'
    end
  end

  def destroy
    @paymentMethod = PaymentMethod.find(params[:id])
    canDestroy = true
    if current_user.subscribed
      if current_user.subscription_payment_method_id == @paymentMethod.id
        canDestroy = false
      end
    end
    if canDestroy
      if @paymentMethod.destroy
        flash[:success] = "El método de pago " + @paymentMethod.card + ' ha sido borrado con éxito'
      else
        flash[:index_error] = "Algo salió mal"
      end
    else
      flash[:index_error] = 'No se puede borrar el método de pago ' + @paymentMethod.card + ' porque se encuentra asociado al servicio de suscripción premium. Para eliminarlo debe cambiar el método de pago asociado al servicio de suscripción premium'
    end
    redirect_to payment_methods_path
  end

end
