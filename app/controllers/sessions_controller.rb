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
      if user.activated?
        log_in(user)
        # forget user on else is to clear any existing cookies
        input_params[:remember_me].to_i == 1 ? remember(user) : forget(user)
        flash[:success] = "Logged in sucessfully"
        redirect_back_or(user)
      else
        message = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = "Invalid email, password combination"
      render "sessions/new"
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

  private

  def session_params
    params.require(:session).permit(:email, :password, :remember_me)
  end
end
