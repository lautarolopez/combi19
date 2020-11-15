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
            flash[:success] = "City " + @city.name + ", " + @city.state + " successfully created"
            redirect_to cities_path#, notice: "City" + @city.name + ", " + @city.state + "successfully created"
          else
            @aux = City.find_by(name: @city.name, state: @city.state)
            if @aux != nil
                flash[:error] = "The city " + @city.name + " already exists in the state " + @city.state
            else 
                flash[:error] = "Something went wrong"
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
          flash[:success] = "City " + @city.name + ", " + @city.state + " successfully updated"
          redirect_to cities_path
        else
            @aux = City.find_by name: @city.name, state: @city.state
            if @aux != nil
               flash[:error] = "The city already exists in the state"
            else 
                flash[:error] = "Something went wrong"
            end
            render 'edit'
        end
    end

    def index
        @cities = City.all
    end

    def destroy
        @city = City.find(params[:id])
        if @city.destroy
            flash[:success] = "City" + @city.name + ", " + @city.state + "successfully deleted."
            redirect_to cities_path
        else
            flash[:error] = "Something went wrong"
            redirect_to cities_path
        end
    end
end

