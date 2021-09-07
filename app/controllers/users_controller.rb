class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @book = Book.new
    @books = @user.books

  end

  def edit
    @user = User.find(params[:id])
    if @user == current_user
      render :edit
    else
      redirect_to user_path(current_user)
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user.id), notice: 'You have updated user successfully.'
    else
      render :edit
    end
  end

  def index
    @users = User.all
    @book=Book.new
    @user = current_user
  end

  def followings
    @user = User.find(params[:id])
    @users = @user.followings.all

  end
  
  def followers
    @user = User.find(params[:id])
    @users = @user.followers.all
  end
  
  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end
end
