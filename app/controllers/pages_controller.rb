class PagesController < ApplicationController
  def home
  @dogs = Dog.order(created_at: :desc)
  end

  def about
  end
end
