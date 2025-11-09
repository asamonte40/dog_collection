class PagesController < ApplicationController
  def home
    @recent_dogs = Dog.order(created_at: :desc).limit(6)
  end

  def about
  end
end
