class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :require_login

  private
    def logged_in?
      session[:current_user_id].present? and Person.exists?(session[:current_user_id])
    end
    def require_login
      unless logged_in?
        flash[:error] = "Please log in to access this page"
        redirect_to new_login_url
      end
    end
end
