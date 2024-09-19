class PeopleController < ApplicationController
  before_action :set_person, only: %i[ edit update destroy ]
  before_action :require_administrator

  # GET /people
  def index
    @people = Person.all
  end

  # GET /people/new
  def new
    @person = Person.new
  end

  # GET /people/1/edit
  def edit
  end

  # POST /people
  def create
    @person = Person.new(person_params)
    if @person.save
      redirect_to people_url, flash: { info: "User was successfully created." }
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /people/1
  def update
    if @person.update(person_params)
      redirect_to people_url, flash: { info: "User was successfully updated." }
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /people/1
  def destroy
    @person.destroy!
    redirect_to people_url, flash: { info: "User was successfully deleted." }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def person_params
      params.require(:person).permit(:name, :is_administrator)
    end

    def require_administrator
      unless @current_user.is_administrator?
        flash[:danger] = "The administrator functionality can only be accessed by administrators."
        redirect_to root_url
      end
    end
end
