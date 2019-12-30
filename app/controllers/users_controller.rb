# frozen_string_literal: true

# NOTE: Helper modules should be included explicitly
class UsersController < ApplicationController
  include ApplicationHelper

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
      redirect_to user_path(@user)
    else
      render "users/new"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
