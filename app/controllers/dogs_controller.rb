class DogsController < ApplicationController
  def index
    @dogs = Dog.includes(:breed, :owner).all
  end

  def show
    @dog = Dog.find(params[:id])
  end
end
