class RoutesController < ApplicationController
    def new
		if current_user == nil || current_user.role != "admin"
			redirect_to root_path
		end
        @route = Route.new
    end
    
    def index
		if current_user == nil || current_user.role != "admin"
			redirect_to root_path
		end
        @routes = Route.all
    end

    def create
        @route = Route.new(params.require(:route).permit(:origin_id, :destination_id, extra_ids: []));
        if @route.save
            flash[:success] = "La ruta " + @route.origin.name.titleize + ", " + @route.origin.state.titleize + " - " + @route.destination.name.titleize + ", " + @route.destination.state.titleize + " ha sido creada con éxito!"
            redirect_to routes_path
        else
            @aux = Route.find_by(origin: @route.origin, destination: @route.destination)
            if @aux != nil
                flash[:form_error] = "La ruta " + @route.origin.name.titleize + ", " + @route.origin.state.titleize + " - " + @route.destination.name.titleize + ", " + @route.destination.state.titleize + " ya existe"
            else 
                flash[:form_error] = "Algo salió mal."
            end
            render 'new'
        end
    end

    def edit
		if current_user == nil || current_user.role != "admin"
			redirect_to root_path
		end
    	@route = Route.find(params[:id])
    end

    def update
    	@route = Route.find(params[:id])
        @route.attributes = params.require(:route).permit(:origin_id, :destination_id, extra_ids: [])
        if @route.save
          flash[:success] = "La ruta " + @route.origin.name.titleize + ", " + @route.origin.state.titleize + " - " + @route.destination.name.titleize + ", " + @route.destination.state.titleize + " ha sido actualizada con éxito!"
          redirect_to routes_path
        else
            @aux = Route.find_by(origin: @route.origin, destination: @route.destination)
            if @aux != nil
                flash[:form_error] = "La ruta " + @route.origin.name.titleize + ", " + @route.origin.state.titleize + " - " + @route.destination.name.titleize + ", " + @route.destination.state.titleize + " ya existe"
            else 
                flash[:form_error] = "Algo salió mal"
            end
            render 'edit'
        end
    end

    def destroy
    	@route = Route.find(params[:id])
        if (@route.travels.count > 0)
            flash[:index_error] = "La ruta " + @route.origin.name.titleize + ", " + @route.origin.state.titleize + " - " + @route.destination.name.titleize + ", " + @route.destination.state.titleize + " no se puede borrar porque tiene viajes asociados"
        else
            if @route.destroy
                flash[:success] = "La ruta " + @route.origin.name.titleize + ", " + @route.origin.state.titleize + " - " + @route.destination.name.titleize + ", " + @route.destination.state.titleize + " ha sido borrada con éxito."
            else
                flash[:index_error] = "Algo salió mal"
            end
        end
        redirect_to routes_path
    end
end