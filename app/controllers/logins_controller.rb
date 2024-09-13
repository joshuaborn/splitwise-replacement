class LoginsController < ApplicationController
  skip_before_action :require_login, only: [ :new, :create ]

  def new
    @people = Person.all
  end

  def create
    begin
      person = Person.find(params[:person_id])
      session[:current_user_id] = person.id
      redirect_to root_path
    rescue ActiveRecord::RecordNotFound
      session.delete(:current_user_id)
      flash[:danger] = "User with ID " + params[:person_id] + " doesn't exist."
      redirect_to new_login_path
    end
  end

  def destroy
      if session[:current_user_id] then
        session.delete(:current_user_id)
        flash[:info] = "Logged out."
      end
      redirect_to new_login_path
  end
end
