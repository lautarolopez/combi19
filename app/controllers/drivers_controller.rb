class DriversController < ApplicationController

    def index
        if current_user == nil || current_user.role != "admin"
			redirect_to root_path
		end
        @drivers = User.drivers
    end

    def express_sell
        if current_user == nil || current_user.role != "driver"
			redirect_to root_path
        end
        @user = User.new
    end

    def show
        @driver = User.find(params[:id])
    end

    def new_driver
        @user = User.new
    end

    def create_passenger
        @user = User.create(email: params[:user][:email], password: "combi19", name: params[:user][:name], last_name: params[:user][:last_name], dni: params[:user][:dni], birth_date: params[:user][:birth_date], role: "driver", subscribed: false)
        if @user.save
            flash[:success] = "El pasajero " + @user.name + " " + @user.last_name + " ha sido creado con éxito!"
            @travel = Travel.current.where("driver_id = ?", current_user.id).first
            render 'express_ticket'
        else
            flash[:form_new_error] = @user.errors.full_messages
            render 'express_sell'
        end
    end

    def find_passenger
        @user = User.find_by_email(params[:user][:email])
        if @user != nil
            @travel = Travel.current.where("driver_id = ?", current_user.id).first
            render 'express_ticket'
        else
            flash[:form_existing_error] = "No existe un usuario con este correo electrónico."
            @user = User.new
            render 'express_sell'
        end
    end

    def finish_ticket
        @ticket = Ticket.create(user_id: params[:user_id], travel_id: params[:travel_id], price: params[:price])
        flash[:success] = "Pasaje vendido correctamente."
        redirect_to travels_path
    end

    def create_driver
        @user = User.create(email: params[:user][:email], password: "combi19", name: params[:user][:name], last_name: params[:user][:last_name], dni: params[:user][:dni], birth_date: params[:user][:birth_date], role: "driver", subscribed: false)
        if @user.save
            flash[:success] = "El chofer " + @user.name + " " + @user.last_name + " ha sido creado con éxito!"
            redirect_to drivers_path
        else
            flash[:form_error] = @user.errors.full_messages
            render 'new_driver'
        end
    end

    def destroy
        @driver = User.find(params[:id])
        if Travel.future.where("driver_id = ?", @driver.id).size == 0
            @pastTravels = Travel.previous.where("driver_id = ?", @driver.id)
            @pastTravels.each do |travel|
                travel.driver_id = nil
                travel.save
            end
            if @driver.destroy
                flash[:success] = 'El chofer ha sido eliminado con éxito.'
                redirect_to drivers_path
            else
                @pastTravels.each do |travel|
                    travel.driver_id = @driver.id
                    travel.save
                end 
                flash[:index_error] = 'Algo salió mal.'
                redirect_to drivers_path
            end
        else
            flash[:index_error] = 'El chofer no se pudo eliminar porque tiene viajes pendientes.'
            redirect_to drivers_path
        end
    end
    
end
