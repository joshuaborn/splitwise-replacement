class LoginsController < ApplicationController
  def new
  end

  def create
    begin
      person = Person.find(params[:person_id])
      session[:current_user_id] = person.id
      redirect_to root_url
    rescue ActiveRecord::RecordNotFound
      session[:current_user_id] = nil
      flash[:error] = "User with ID " + params[:person_id] + " doesn't exist"
      redirect_to logins_new_url
    end
  end

  def destroy
  end
end
