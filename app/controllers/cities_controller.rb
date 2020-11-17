class CitiesController < ApplicationController
    def new
        @city = City.new
    end
    
    def index
        @cities = City.all
    end
    def create
        @city = City.create(params.require(:city).permit(:name, :state));
        if @city.save
            flash[:success] = @city.name.titleize + ", " + @city.state.titleize + " ha sido creada con éxito!"
            flash[:success] = @city.name.capitalize + ", " + @city.state.capitalize + " ha sido creada con éxito!"
            redirect_to cities_path
          else
            @aux = City.find_by(name: @city.name, state: @city.state)
            if @aux != nil
                flash[:error] = "La ciudad " + @city.name.titleize + " ya existe en la provincia " + @city.state.titleize
                flash[:error] = "La ciudad " + @city.name.capitalize + " ya existe en la provincia " + @city.state.capitalize
            else 
                flash[:error] = "Algo salió mal."
            end
            render 'new'
          end
    end
    def edit
        @city = City.find(params[:id])
    end
    def update
        @city = City.find(params[:id])
        if @city.update(params.require(:city).permit(:name, :state))
          flash[:success] = @city.name.titleize + ", " + @city.state.titleize + " ha sido actualizada con éxito!"
          flash[:success] = @city.name.capitalize + ", " + @city.state.capitalize + " ha sido actualizada con éxito!"
          redirect_to cities_path
        else
            @aux = City.find_by(name: @city.name, state: @city.state)
            if @aux != nil
                flash[:error] = "La ciudad " + @city.name.titleize + " ya existe en la provincia " + @city.state.titleize
                flash[:error] = "La ciudad " + @city.name.capitalize + " ya existe en la provincia " + @city.state.capitalize
            else 
                flash[:error] = "Algo salió mal"
            end
            render 'edit'
        end
    end
    def destroy
        @city = City.find(params[:id])
        if @city.destroy
            flash[:success] = @city.name.titleize + ", " + @city.state.titleize + " ha sido borrada con éxito."
            flash[:success] = @city.name.capitalize + ", " + @city.state.capitalize + " ha sido borrada con éxito."
            redirect_to cities_path
        else
            flash[:error] = "Algo salió mal"
            redirect_to cities_path
        end
    end
end

