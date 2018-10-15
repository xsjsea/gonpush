class CampaignsController < ApplicationController
  layout :admin_layout
  before_action :set_campaign, only: [:show, :edit, :update, :destroy]
   
  # GET /campaigns
  # GET /campaigns.json
  def index
    #@campaigns = Campaign.all
    current_user
    @user=User.find_by_id(session[:user_id])
    @campaign = Campaign.new  
  
  end

  # GET /campaigns/1
  # GET /campaigns/1.json
  def show
  current_user
  user_id=session[:user_id]
  searchword=params[:searchword]
  if searchword==nil
  @creators=User.select("users.id,users.username,users.description,users.avatar,IFNULL(v_socialaccounts.totalpraises,1000) totalpraises,IFNULL(v_socialaccounts.totalfans,1000) totalfans,IFNULL(v_socialaccounts.totalreaders,1000) totalreaders,IFNULL(v_services.min_service_price,1000) min_service_price")
 .joins("left join v_socialaccounts on users.id = v_socialaccounts.creator_id left join v_services on users.id=v_services.creator_id where users.usertype='0'") 
  else
     @creators=User.select("users.id,users.username,users.description,users.avatar,IFNULL(v_socialaccounts.totalpraises,1000) totalpraises,IFNULL(v_socialaccounts.totalfans,1000) totalfans,IFNULL(v_socialaccounts.totalreaders,1000) totalreaders,IFNULL(v_services.min_service_price,1000) min_service_price")
 .joins("left join v_socialaccounts on users.id = v_socialaccounts.creator_id left join v_services on users.id=v_services.creator_id where users.usertype='0' and users.username like '%#{searchword}%'") 
 end
 # @creators=User.new.getcreator 
  if @creators.length>0
  creator_id=@creators[0].id
  #@creatorservices=Service.find_by_creator_id(@creators[0].id)
  @services=Service.select("services.creator_id,services.service_name,services.service_description,services.service_price").joins("where services.creator_id=#{creator_id}")
  end
  #@services=Services.all
  @user=User.find_by_id(session[:user_id])
  @order=Order.new
 
end

 
  # GET /campaigns/new
  def new
    current_user
    user_id=session[:user_id]
    @campaign = Campaign.new
   
  end

  # GET /campaigns/1/edit
  def edit
  end

  # POST /campaigns
  # POST /campaigns.json
  def create
    @campaign = Campaign.new(campaign_params)

    respond_to do |format|
      if @campaign.save
        format.html { redirect_to @campaign, notice: '' }
        format.json { render :show, status: :created, location: @campaign }
      else
        format.html { render :new }
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /campaigns/1
  # PATCH/PUT /campaigns/1.json
  def update
    respond_to do |format|
      if @campaign.update(campaign_params)
        format.html { redirect_to @campaign, notice: '' }
        format.json { render :show, status: :ok, location: @campaign }
      else
        format.html { render :edit }
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /campaigns/1
  # DELETE /campaigns/1.json
  def destroy
    @campaign.destroy
    respond_to do |format|
      format.html { redirect_to campaigns_url, notice: '' }
      format.json { head :no_content }
    end
  end
 
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_campaign
      logged_in_user 
      @campaign = Campaign.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def campaign_params
      params.require(:campaign).permit(:name, :description, :start, :budget,:user_id)
    end

    def admin_layout
      # Check if logged in, because current_user could be nil.
      if(1==1)
        "marketer"
      else
        "application"
      end
    end
end
