class TravelsController < ApplicationController
    def step_new
    	@travel = Travel.new
    end

    def new
    	@travel = Travel.new(params.require(:travel).permit(:route_id, :capacity, :price, :date_departure, :date_arrival))
    end

    def index
        @travels = Travel.all
    end

    def create
		@travel = Travel.create(params.require(:travel).permit(:route_id, :capacity, :price, :date_departure, :date_arrival, :combi_id, :driver_id))
        if @travel.save
            flash[:success] = "El viaje " + @travel.route.origin.name.titleize + ", " + @travel.route.origin.state.titleize + " - " + @travel.route.destination.name.titleize + ", " + @travel.route.destination.state.titleize + " del día " + @travel.date_departure.strftime('%m/%d/%Y') + " a las " + @travel.date_departure.strftime('%I:%M %p') + " ha sido creada con éxito!"
            redirect_to travels_path
        else
            flash[:error] = "Algo salió mal."
            render 'prueba'
        end
    end

    def destroy
    	@travel = Travel.find(params[:id])
        if @travel.destroy
            flash[:success] = "El viaje " + @travel.route.origin.name.titleize + ", " + @travel.route.origin.state.titleize + " - " + @travel.route.destination.name.titleize + ", " + @travel.route.destination.state.titleize + " del día " + @travel.date_departure.strftime('%m/%d/%Y') + " a las " + @travel.date_departure.strftime('%I:%M %p') + " ha sido borrado con éxito"
            redirect_to travels_path
        else
            flash[:error] = 'Algo salió mal'
            redirect_to travels_path
        end
    end
end
