class CitiesController < ApplicationController
    def new
		if current_user == nil || current_user.role != "admin"
			redirect_to root_path
		end
        @city = City.new
    end
    
    def index
		if current_user == nil || current_user.role != "admin"
			redirect_to root_path
		end
        @cities = City.all
    end

    def create
        @city = City.new(params.require(:city).permit(:name, :state))
        @city.attributes = {name: @city.name.downcase, state: @city.state.downcase}
        if @city.save
            flash[:success] = @city.name.titleize + ", " + @city.state.titleize + " ha sido creada con éxito!"
            redirect_to cities_path
          else
            @aux = City.find_by(name: @city.name, state: @city.state)
            if @aux != nil
                flash[:form_error] = "La ciudad " + @city.name.titleize + " ya existe en la provincia " + @city.state.titleize
            else 
                flash[:form_error] = "Algo salió mal."
            end
            render 'new'
          end
    end

    def show
        if current_user == nil || current_user.role != "admin"
            redirect_to root_path
        end
        @city = City.find(params[:id])
    end

    def edit
		if current_user == nil || current_user.role != "admin"
			redirect_to root_path
		end
        @city = City.find(params[:id])
    end

    def update
        @city = City.find(params[:id])
        @city.attributes = params.require(:city).permit(:name, :state)
        if @city.save
          flash[:success] = @city.name.titleize + ", " + @city.state.titleize + " ha sido actualizada con éxito!"
          redirect_to cities_path
        else
            @aux = City.find_by(name: @city.name.downcase, state: @city.state.downcase)
            if @aux != nil
                flash[:form_error] = "La ciudad " + @city.name.titleize + " ya existe en la provincia " + @city.state.titleize
            else 
                flash[:form_error] = "Algo salió mal"
            end
            render 'edit'
        end
    end

    def destroy
        @city = City.find(params[:id])
        @routes = @city.routes_from + @city.routes_to
        @routes.each do |r|
            if (r.travels.count > 0) 
                flash[:index_error] = @city.name.titleize + ", " + @city.state.titleize + " no se puede borrar porque existen viajes asociados"
                break
            end
        end
        if (flash[:index_error] == nil)
            if @city.destroy
                flash[:success] = @city.name.titleize + ", " + @city.state.titleize + " ha sido borrada con éxito."
            else
                flash[:index_error] = "Algo salió mal"
            end
        end
        redirect_to cities_path
    end
end

