class ExtrasController < ApplicationController

    def new
		if current_user == nil || current_user.role != "admin"
			redirect_to root_path
		end
        @extra = Extra.new
    end
    
    def create
        @extra = Extra.create(params.require(:extra).permit(:name, :description, :price));
        if @extra.save
            flash[:success] = "El insumo " + @extra.name + " ha sido creado con éxito!"
            redirect_to extras_path
          else
            @aux = Extra.find_by name: @extra.name
            if @aux != nil
               flash[:error] = "El insumo " + @extra.name + "ya existe"
            else 
                flash[:error] = "Algo salió mal"
            end
            render 'new'
          end
    end

    def edit
		if current_user == nil || current_user.role != "admin"
			redirect_to root_path
		end
        @extra = Extra.find(params[:id])
    end

    def update
        @extra = Extra.find(params[:id])
        if @extra.update_attributes(params.require(:extra).permit(:name, :description, :price))
            flash[:success] = "El insumo " + @extra.name + " ha sido actualizado con éxito!"
          redirect_to extras_path
        else
            @aux = Extra.find_by name: @extra.name
            if @aux != nil
               flash[:error] = "El insumo " + @extra.name + "ya existe"
            else 
                flash[:error] = "Algo salió mal"
            end
            render 'edit'
        end
    end

    def index
		if current_user == nil || current_user.role != "admin"
			redirect_to root_path
		end
        @extras = Extra.all
    end

    def destroy
        @extra = Extra.find(params[:id])
        if @extra.destroy
               flash[:error] = "El insumo " + @extra.name + " ha sido borrado con éxito"
            redirect_to extras_url
        else
                flash[:error] = "Algo salió mal"
            redirect_to extras_url
        end
    end
    
    
    
end
