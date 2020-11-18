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
        if @travel.s
            flash[:success] = "El viaje " + @route.origin.name.titleize + ", " + @route.origin.state.titleize + "-" + @route.destination.name.titleize + ", " + @route.destination.state.titleize + "......" + " ha sido creada con éxito!"
            redirect_to travels_path
        else
            flash[:error] = "Algo salió mal."
            render 'prueba'
        end
    end
end
