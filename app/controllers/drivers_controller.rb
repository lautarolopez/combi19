class DriversController < ApplicationController

    def index
        if current_user == nil || current_user.role != "admin"
         redirect_to root_path
     end
     @drivers = User.drivers
    end

    def show
        @driver = User.find(params[:id])

        if(params[:date])
            @date = DateTime.new(params[:date][:year].to_i,params[:date][:month].to_i)
            if(@date.year==DateTime.current.year and @date.month==DateTime.current.month)
                @date_end = DateTime.current
            else
                @date_end = @date.at_end_of_month
            end
            @travels = @driver.driving_travels.finished.where("date_arrival > ? and date_arrival < ?", @date, @date_end)
        else
            @travels = @driver.driving_travels.finished.last_month
        end      


        @total_hours = 0        
        @travels.each do |travel|
            @total_hours = @total_hours + ((travel.date_arrival - travel.date_departure).floor/3600)

        end
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