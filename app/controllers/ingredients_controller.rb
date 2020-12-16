class IngredientsController < ApplicationController
  before_action :get_instance_from_id, only: [:show, :edit, :update, :destroy,:new]

  def index
    @ingredients = Ingredient.all
  end

  def show
  end

  def new
    @ingredient = Ingredient.new
  end

  def create
    @ingredient = Ingredient.new(required_params)
    if @ingredient.save
      redirect_to ingredient_path(@ingredient)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @ingredient.update(required_params)
      redirect_to ingredient_path(@ingredient)
    else
      render :new
    end
  end

  def destroy
    @ingredient.destroy
    redirect_to ingredients_path
  end

  private

  def get_instance_from_id
    @ingredient = Ingredient.find(params[:id])
  end

  def required_params
    params.require(:ingredient).permit(:name)
  end
end