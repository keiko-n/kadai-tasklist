class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :show]
  
  def index
    @users = User.all.page(params[:page])
  end

  def show
    @user = User.find(params[:id])
    if logged_in?
    @task = current_user.tasks.build
    @tasks = current_user.tasks.order('created_at DESC').page(params[:page])
    end
    
  end

  def new
    @user = User.new
    @tasks = @user.tasks.order('created_at DESC').page(params[:page])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in@user
      flash[:success] = 'ユーザを登録しました'
      redirect_to :root
    else
      flash.now[:danger] = 'ユーザ登録に失敗しました'
      render :new
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
