class BreedsController < ApplicationController
  def index
    @breeds = Breed.all
    @breeds = @breeds.where("name LIKE ?", "%#{params[:q]}%") if params[:q].present?
    @breeds = @breeds.order(:name).page(params[:page]).per(12)
  end

  def show
    @breed = Breed.find(params[:id])
    @dogs = @breed.dogs
  end
end
