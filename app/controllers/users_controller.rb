class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    result = Users::Create.run(**user_params)

    if result.valid?
      redirect_to users_path(result.result), notice: "User was successfully created."
    else
      @errors = result.errors.full_messages
      @user = User.new(user_params.except(:interests, :skills))
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :name,
      :surname,
      :patronymic,
      :email,
      :age,
      :nationality,
      :country,
      :gender,
      interests: [],
      skills: []
    )
  end
end
