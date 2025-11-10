class OwnersController < ApplicationController
  def index
    @owners = Owner.all
    @owners = @owners.where("first_name LIKE ? OR last_name LIKE ?", "%#{params[:q]}%", "%#{params[:q]}%") if params[:q].present?
  end

  def show
    @owner = Owner.find(params[:id])
  end

  private

  def owner_params
    params.require(:owner).permit(:first_name, :last_name, :email, :address)
  end
end
