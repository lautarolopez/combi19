class RoutesController < ApplicationController
	def new
        @route = Route.new
    end
    
    def index
        @routes = Route.all
    end

    def create
        @route = Route.create(params.require(:route).permit(:origin_id, :destination_id, extra_ids: []));
        if @route.save
            flash[:success] = "La ruta " + @route.origin.name.titleize + "-" + @route.destination.name.titleize + " ha sido creada con éxito!"
            redirect_to routes_path
          else
            @aux = Route.find_by(origin: @route.origin, destination: @route.destination)
            if @aux != nil
                flash[:error] = "La ruta " + @route.origin.name.titleize + "-" + @route.destination.name.titleize + " ya existe"
            else 
                flash[:error] = "Algo salió mal."
            end
            render 'new'
          end
    end

    def edit
    	@route = Route.find(params[:id])
    end

    def update
    	@route = Route.find(params[:id])
        if @route.update(params.require(:route).permit(:origin_id, :destination_id, extra_ids: []));
          flash[:success] = "La ruta " + @route.origin.name.titleize + "-" + @route.destination.name.titleize + " ha sido actualizada con éxito!"
          redirect_to routes_path
        else
            @aux = Route.find_by(origin: @route.origin, destination: @route.destination)
            if @aux != nil
                flash[:error] = "La ruta " + @route.origin.name.titleize + "-" + @route.destination.name.titleize + " ya existe"
            else 
                flash[:error] = "Algo salió mal"
            end
            render 'edit'
        end
    end

    def destroy
    end
end