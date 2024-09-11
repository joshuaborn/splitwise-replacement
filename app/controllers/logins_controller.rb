class LoginsController < ApplicationController
  def new
  end

  def create
    begin
      person = Person.find(params[:person_id])
      session[:current_user_id] = person.id
      redirect_to root_path
    rescue ActiveRecord::RecordNotFound
      session.delete(:current_user_id)
      flash[:error] = "User with ID " + params[:person_id] + " doesn't exist"
      redirect_to new_login_path
    end
  end

  def destroy
      if session[:current_user_id] then
        session.delete(:current_user_id)
        flash[:notice] = "Logged out"
      end
      redirect_to new_login_path
  end
end
