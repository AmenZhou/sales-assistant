class Mine::ProfileController < ApplicationController
  def show
  end

  def edit
  end

  def update
    if current_user.update(profile_params)
      redirect_to mine_profile_path
    else
      flash[:error] = current_user.errors.full_messages.join(', ')
      render :edit
    end
  end

  private

  def profile_params
    params.require(:user).permit(:username)
  end
end
