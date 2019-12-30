# frozen_string_literal: true
class SessionsController < ApplicationController
  include ApplicationHelper

  def new
    @title = page_title("Login")
  end

  def create
    input_params = session_params
    user = User.find_by(email: input_params[:email].downcase)

    if user && user.authenticate(input_params[:password])
      log_in(user)
      flash[:success] = "Logged in sucessfully"
      redirect_to user_path(user)
    else
      flash.now[:danger] = "Invalid email, password combination"
      render "sessions/new"
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
