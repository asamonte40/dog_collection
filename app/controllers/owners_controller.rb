class OwnersController < ApplicationController
  def index
    @owners = Owner.all
    if params[:q].present?
     query = "%#{params[:q]}%"
      @owners = @owners.where("first_name LIKE ? OR last_name LIKE ?", query, query)
    end
    @owners = @owners.page(params[:page]).per(9)
  end

  def show
    @owner = Owner.find(params[:id])
  end
end
