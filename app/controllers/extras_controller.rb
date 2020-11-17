class ExtrasController < ApplicationController

    def new
        @extra = Extra.new
    end
    
    def create
        @extra = Extra.create(params.require(:extra).permit(:name, :description, :price));
        if @extra.save
            flash[:success] = "Object successfully created"
            redirect_to extras_path
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

    def edit
        @extra = Extra.find(params[:id])
    end

    def update
        @extra = Extra.find(params[:id])
        if @extra.update_attributes(params.require(:extra).permit(:name, :description, :price))
          flash[:success] = "Extra was successfully updated"
          redirect_to extras_path
        else
            @aux = Extra.find_by name: @extra.name
            if @aux != nil
               flash[:error] = "The product already exists"
            else 
                flash[:error] = "Something went wrong"
            end
            render 'edit'
        end
    end

    def index
        @extras = Extra.all
    end

    def destroy
        @extra = Extra.find(params[:id])
        if @extra.destroy
            flash[:success] = 'Object was successfully deleted.'
            redirect_to extras_url
        else
            flash[:error] = 'Something went wrong'
            redirect_to extras_url
        end
    end
    
    
    
end
