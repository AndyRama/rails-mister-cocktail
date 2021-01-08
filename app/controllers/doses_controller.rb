class DosesController < ApplicationController
  def new
    @cocktail = Cocktail.find(params[:cocktail_id])
    @dose = Dose.new
  end
 
  def create
    @cocktail = Cocktail.find(params[:cocktail_id])
    # ingredient/description pair
    # @ingredient = Ingredient.find(params[:dose][:ingredient_id])
    # it gives an error if no ingredient selected
    @dose = Dose.new(dose_params)
    # @dose.ingredient = @ingredient
    @dose.cocktail = @cocktail
    if @dose.save
      redirect_to cocktail_path(@cocktail)
    else
      render :new
    end
  end

  def destroy
    @dose = Dose.find(params[:id])
    redirect_to cocktail_path(@dose.cocktail)
    @dose.destroy
  end

  private

  def dose_params
    params.require(:dose).permit(:description, :ingredient_id)
  end
end