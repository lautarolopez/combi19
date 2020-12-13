class DriversController < ApplicationController

    def index
        if current_user == nil || current_user.role != "admin"
			redirect_to root_path
		end
        @drivers = User.drivers
    end

    def show
        @driver = User.find(params[:id])
    end

    def new_driver
        @user = User.new
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
