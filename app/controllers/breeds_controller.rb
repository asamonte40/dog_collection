class BreedsController < ApplicationController
  def index
    @breeds = Breed.order(:name).page(params[:page]).per(12)
  end

  def show
    @breed = Breed.find(params[:id])
    @dogs = @breed.dogs
  end
end
