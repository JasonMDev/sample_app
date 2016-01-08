class UsersController < ApplicationController
  
  def show
  	@user = User.find(params[:id])
  	# | byebug debugger command.
  	#debugger  	
  	# | Use "debugger" and Rails console will be added in the
  	# | rails server console. 
  	# | When happy, Ctrl+D to resume execution.
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # Handle a successful save.
    else
      render 'new'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

end

