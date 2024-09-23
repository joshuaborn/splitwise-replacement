class ApplicationController < ActionController::Base
  before_action :require_login

  private
    def logged_in?
      session[:current_user_id].present? and (@current_user = Person.where(id: session[:current_user_id]).first)
    end
    def require_login
      unless logged_in?
        flash[:warning] = "Please log in to access this page."
        redirect_to new_login_url
      end
    end
end
