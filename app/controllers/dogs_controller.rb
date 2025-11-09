class DogsController < ApplicationController
  @dogs = Dog.includes(:breed, :owner).all
  def index
  end
end
