class DogsController < ApplicationController
  def index
    @dogs = Dog.includes(:breed, :owner).all
    @dogs = @dogs.where("name LIKE ?", "%#{params[:q]}%") if params[:q].present?
    @dogs = @dogs.where(breed_id: params[:breed_id]) if params[:breed_id].present?
    @dogs = @dogs.order(:name).page(params[:page]).per(12)
  end

  def show
    @dog = Dog.find(params[:id])
  end
end
