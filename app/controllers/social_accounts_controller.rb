class SocialAccountsController < ApplicationController
  before_action :set_social_account, only: [:show, :edit, :update, :destroy]
  layout :products_layout
  # GET /social_accounts
  # GET /social_accounts.json
  def index
     #@social_accounts = SocialAccount.all
     user_id=session[:user_id]
     @social_accounts = SocialAccount.select("social_accounts.fans,social_accounts.readers,social_accounts.praises,social_accounts.comments,social_channels.name,
social_accounts.channel_id,social_accounts.nickname,social_accounts.id,social_accounts.creator_id").joins(" left join social_channels on social_accounts.channel_id=social_channels.id where social_accounts.creator_id=#{user_id}")
  end

  # GET /social_accounts/1
  # GET /social_accounts/1.json
  def show
  end

  # GET /social_accounts/new
  def new
    @social_account = SocialAccount.new
    
    @social_channels =SocialChannel.all
  end

  # GET /social_accounts/1/edit
  def edit
     @social_channels =SocialChannel.all
  end

  # POST /social_accounts
  # POST /social_accounts.json
  def create
    curTime =Date.today
    user_id= params[:creator_id]

    channel_id=params[:channel_id]
    nickname=params[:nickname]
    fans=params[:fans]
    readers=params[:readers]
    comments=params[:comments]
    praises=params[:praises]
     sql = ActiveRecord::Base.connection()        
      sql.insert "INSERT INTO social_accounts SET channel_id='#{channel_id}', nickname='#{nickname}', 
      readers=#{readers},
      fans=#{fans},
      comments='#{comments}', 
      praises='#{praises}',
      creator_id='#{user_id}',
      created_at='#{curTime}',updated_at='#{curTime}'"  

       respond_to do |format|
      #if @social_account.save
         @social_accounts = SocialAccount.select("social_accounts.fans,social_accounts.readers,social_accounts.praises,social_accounts.comments,social_accounts.channel_name,
social_accounts.channel_id,social_accounts.nickname,social_accounts.id,social_accounts.creator_id").joins("where social_accounts.creator_id=#{user_id}")
 
        format.html { render :index, notice: 'Social account was successfully created.' }
        format.json { render :show, status: :created, location: @social_account }
      #else
      #  format.html { render :new }
      #  format.json { render json: @social_account.errors, status: :unprocessable_entity }
      end



  end
  def upatesocialaccounts
    id= params[:account_id]
    user_id= params[:creator_id]
    channel_id=params[:channel_id]
    nickname=params[:nickname]
    fans=params[:fans]
    readers=params[:readers]
    comments=params[:comments]
    praises=params[:praises]

    sch = SocialAccount.find_by_id(id)
    sch.update_attribute('channel_id', channel_id)
    sch.update_attribute('nickname', nickname)
    sch.update_attribute('fans', fans)
    sch.update_attribute('readers', readers)
    sch.update_attribute('comments', comments)
    sch.update_attribute('praises', praises)
    respond_to do |format| 
         @social_accounts = SocialAccount.select("social_accounts.fans,social_accounts.readers,social_accounts.praises,social_accounts.comments,social_channels.name,
social_accounts.channel_id,social_accounts.nickname,social_accounts.id,social_accounts.creator_id").joins(" left join social_channels on social_accounts.channel_id=social_channels.id where social_accounts.creator_id=#{user_id}")
        format.html { render :index, notice: 'Social account was successfully updated.' }
        format.json { render :show, status: :ok, location: @social_account }
      end

  end
  # PATCH/PUT /social_accounts/1
  # PATCH/PUT /social_accounts/1.json
  def update
    user_id=session[:user_id]
    respond_to do |format|
      if @social_account.update(social_account_params)
       @social_accounts = SocialAccount.select("social_accounts.fans,social_accounts.readers,social_accounts.praises,social_accounts.comments,social_channels.name,
social_accounts.channel_id,social_accounts.nickname,social_accounts.id,social_accounts.creator_id").joins(" left join social_channels on social_accounts.channel_id=social_channels.id where social_accounts.creator_id=#{user_id}")
 
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
         @social_accounts = SocialAccount.select("social_accounts.fans,social_accounts.readers,social_accounts.praises,social_accounts.comments,social_channels.name,
social_accounts.channel_id,social_accounts.nickname,social_accounts.id,social_accounts.creator_id").joins(" left join social_channels on social_accounts.channel_id=social_channels.id where social_accounts.creator_id=#{user_id}")
 
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
      params.require(:social_account).permit(:creator_id, :channel_id, :channel_name, :channel_value,:nickname,:fans,:readers,:praises,:comments)
    end
     def products_layout 
    
       return 'creator'
    
    end
end
