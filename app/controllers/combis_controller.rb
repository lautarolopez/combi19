class CombisController < ApplicationController
	def new
		@combi = Combi.new
	end

	def create
		@combi = Combi.create(params.require(:combi).permit(:licence_plate, :category));
	
		if @combi.save
			flash[:success] = "Combi " + @combi.licence_plate + ", " + @combi.category + " ha sido creada con éxito!"
			redirect_to combis_path
		else
			@aux = Combi.find_by(licence_plate: @combi.licence_plate)
			if @aux != nil
				flash[:error] = "La combi " + @combi.licence_plate + " ya existe."
			else 
				flash[:error] = "Algo salió mal."
			end
			render 'new'
		end
	end

	def index
		@combis = Combi.all
	end

	def edit
		@combi = Combi.find(params[:id])
	end

	def update
		@combi = Combi.find(params[:id])
		
		parametros=params.require(:combi).permit(:licence_plate, :category)
		
		if @combi.update(parametros)
          flash[:success] = "Combi " + @combi.licence_plate + ", " + @combi.category + " ha sido actualizada con éxito!"
          redirect_to combis_path
        else
			@aux = Combi.find_by(licence_plate: @combi.licence_plate)
			if @aux != nil
				flash[:error] = "La combi " + @combi.licence_plate + " ya existe."
			else 
				flash[:error] = "Algo salió mal."
			end
			render 'edit'
		end
	end
end