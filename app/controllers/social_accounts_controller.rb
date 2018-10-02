class SocialAccountsController < ApplicationController
  before_action :set_social_account, only: [:show, :edit, :update, :destroy]
  layout :products_layout
  # GET /social_accounts
  # GET /social_accounts.json
  def index
     #@social_accounts = SocialAccount.all
     user_id=session[:user_id]
     @social_accounts = SocialAccount.select("social_accounts.fans,social_accounts.readers,social_accounts.praises,social_accounts.comments,social_accounts.channel_name,
social_accounts.channel_id,social_accounts.nickname,social_accounts.id,social_accounts.creator_id").joins("where social_accounts.creator_id=#{user_id}")
  end

  # GET /social_accounts/1
  # GET /social_accounts/1.json
  def show
  end

  # GET /social_accounts/new
  def new
    @social_account = SocialAccount.new
  end

  # GET /social_accounts/1/edit
  def edit
  end

  # POST /social_accounts
  # POST /social_accounts.json
  def create
    @social_account = SocialAccount.new(social_account_params)
    user_id=session[:user_id]
    respond_to do |format|
      if @social_account.save
         @social_accounts = SocialAccount.select("social_accounts.fans,social_accounts.readers,social_accounts.praises,social_accounts.comments,social_accounts.channel_name,
social_accounts.channel_id,social_accounts.nickname,social_accounts.id,social_accounts.creator_id").joins("where social_accounts.creator_id=#{user_id}")
 
        format.html { render :index, notice: 'Social account was successfully created.' }
        format.json { render :show, status: :created, location: @social_account }
      else
        format.html { render :new }
        format.json { render json: @social_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /social_accounts/1
  # PATCH/PUT /social_accounts/1.json
  def update
      user_id=session[:user_id]
    respond_to do |format|
      if @social_account.update(social_account_params)
         @social_accounts = SocialAccount.select("social_accounts.fans,social_accounts.readers,social_accounts.praises,social_accounts.comments,social_accounts.channel_name,
social_accounts.channel_id,social_accounts.nickname,social_accounts.id,social_accounts.creator_id").joins("where social_accounts.creator_id=#{user_id}")
 
        format.html { render :index, notice: 'Social account was successfully updated.' }
        format.json { render :show, status: :ok, location: @social_account }
      else
        format.html { render :edit }
        format.json { render json: @social_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /social_accounts/1
  # DELETE /social_accounts/1.json
  def destroy
    user_id=session[:user_id]
    @social_account.destroy
    respond_to do |format|
        @social_accounts = SocialAccount.select("social_accounts.fans,social_accounts.readers,social_accounts.praises,social_accounts.comments,social_accounts.channel_name,
social_accounts.channel_id,social_accounts.nickname,social_accounts.id,social_accounts.creator_id").joins("where social_accounts.creator_id=#{user_id}")
 
      format.html { render :index, notice: 'Social account was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_social_account
      @social_account = SocialAccount.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def social_account_params
      params.require(:social_account).permit(:creator_id, :channel_id, :channel_name, :channel_value)
    end
     def products_layout 
    
       return 'creator'
    
    end
end
