class ExtrasController < ApplicationController

    def new
        @extra = Extra.new
    end
    
    def create
        @extra = Extra.create(params.require(:extra).permit(:name, :description, :price));
        if @extra.save
            flash[:success] = "Object successfully created"
            redirect_to root_path
          else
            @aux = Extra.find_by name: @extra.name
            if @aux != nil
               flash[:error] = "The product already exists"
            else 
                flash[:error] = "Something went wrong"
            end
            render 'new'
          end
    end
    
end
