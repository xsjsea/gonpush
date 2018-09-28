class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  layout :products_layout

 
  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit

  end
 

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        #format.html { redirect_to @user, notice: 'User was successfully created.' }
        #format.json { render :show, status: :created, location: @user }
        session[:user_id] =  @user.id
        if(@user.usertype=="0")
        format.html { redirect_to orders_path,notice: 'User was successfully updated.' }
        else
        format.html { redirect_to campaigns_path,notice: 'User was successfully updated.' }
      end
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
   def inviterequired
    current_user

   end
   def saveinviterequired
    current_user
    inviterequired =params[:inviterequired]
    productselected =params[:productselected]
    CreatorExt.where(userid: session[:user_id]).update_all(inviterequired: inviterequired,productselected:productselected)
   end
   def updatepassword
    current_user
    
   end
  def savepassword
    current_user
    password =params[:password]
    User.where(id:@current_user.id).update_all(password:password)
   end
    def userinfo
    current_user
    user_id=@current_user.id
    User.select("creator_exts.avatar,creator_exts.category_id,users.sex,users.username,users.description,users.user_comment,creator_exts.tags_set").joins("left join creator_exts on users.id= creator_exts.userid where users.id=#{user_id}")

   end
  def saveuserinfo
    current_user

   end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      logged_in_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:status, :usertype, :username, :truename, :password, :province_id, :city_id, :distirct_id, :address, :user_comment,:mobile)
    end
    def products_layout 
    @user=User.find_by_id(session[:user_id]) 
    if @user.usertype=="0"
       return 'creator'
    else
      return 'marketer'
    end
   
 end  
end
