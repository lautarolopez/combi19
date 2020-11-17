class RoutesController < ApplicationController
	def new
        @route = Route.new
    end
    
    def index
        @routes = Route.all
    end

    def create
        @route = Route.create(params.require(:route).permit(:origin, :destination, :extras));
        if @route.save
            flash[:success] = "La ruta " + @route.origin.name + "-" + @route.destination.name + " ha sido creada con éxito!"
            redirect_to routes_path
        else
            @aux = Route.find_by(origin: @route.origin, destination: @route.destination)
            if @aux != nil
                flash[:error] = "La ruta " + @route.origin.name + "-" + @route.destination.name + " ya existe"
            else 
                flash[:error] = "Algo salió mal."
            end
            render 'new'
        end
    end

    def edit
    end

    def update
    end

    def destroy
        @route = Route.find(params[:id])
        if @route.destroy
            flash[:success] = "La ruta " + @route.origin.name + "-" + @route.destination.name + " ha sido borrada con éxito."
            redirect_to routes_path
        else
            flash[:error] = "Algo salió mal"
            redirect_to routes_path
        end
    end
end
