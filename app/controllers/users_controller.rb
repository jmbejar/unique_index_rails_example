class UsersController < ApplicationController
  def index
    raise "problem"
    @users = User.all
    render @users
  end

  def show
    @user = User.find(params[:id])
    render @user
  end

  def create
    user = User.new(user_params)
    if user.save
      respond_to do |format|
        format.html { redirect_to users_path, notice: "User was successfully created." }
        format.json { render json: user, status: :created }
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.json { render json: user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:name)
  end
end
