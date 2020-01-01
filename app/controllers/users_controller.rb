# frozen_string_literal: true

# NOTE: Helper modules should be included explicitly
class UsersController < ApplicationController
  include ApplicationHelper

  # By default, before filters apply to every action in a controller
  before_action :logged_in_user, only: %i[edit update index destroy]
  before_action :correct_user, only: %i[edit update]
  before_action :admin_user, only: %i[destroy]

  def index
    @title = page_title("All users")

    @users = User.paginate(page: params[:page])
  end

  def new
    @title = page_title("Signup")
    @user = User.new
  end

  def show
    @user = User.find(params[:id]) if params.fetch(:id, nil)
    @title = @user.nil? ? page_title : page_title(@user.name)
  end

  def create
    @user = User.new(user_params)

    if @user.save
      log_in(@user)
      flash[:success] = "Sign up successful!"
      # we can use any of these statements
      # redirect_to @user or
      # redirect_to user_url(@user) or
      # redirect_to user_path(@user)
      redirect_to(@user)
    else
      render "new"
    end
  end

  def edit
    @title = page_title("Edit user")
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(user_params)
      flash[:success] = "Successfully updated the user profile"
      redirect_to(@user)
    else
      render "edit"
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to(users_path)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in"
      redirect_to(login_path)
    end
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end
end
