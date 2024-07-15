class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user,only: [:show,:destroy]
  before_action :require_admin, only: [:destroy,:index]

  def index
    @users=User.paginate(page: params[:page], per_page: 2)
  end
  def destroy
    @user.destroy
    flash[:notice] = "User was successfully deleted"
    redirect_to users_path 
  end

  def show
    @articles=@user.articles.paginate(page: params[:page], per_page: 2)
  end
  
  private
  def find_user
    @user=User.find(params[:id])
  end
  def require_admin
    unless current_user.is_admin?
      flash[:alert] = "Only admins can perform that action"
      redirect_to root_path
    end 
  end
end
