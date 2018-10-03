class ServicesController < ApplicationController
  before_action :set_service, only: [:show, :edit, :update, :destroy]
  layout :products_layout
  # GET /services
  # GET /services.json
  def index
    #@services = Service.all
    current_user

   # @services =Service.find_all_by_creator_id(session[:user_id])
   user_id=session[:user_id]
   @services =Service.select("services.id,services.service_name,services.service_description,service_price").joins("where services.creator_id=#{user_id}")
  end

  # GET /services/1
  # GET /services/1.json
  def show
  end

  # GET /services/new
  def new
    @user=User.find_by_id(session[:user_id])
    @service = Service.new
  end

  # GET /services/1/edit
  def edit
   # id=params[:id]
   # @service =Service.find_by_id(id)
  end

  # POST /services
  # POST /services.json
  def create
    @service = Service.new(service_params)
    user_id=session[:user_id]
    respond_to do |format|
      if @service.save
        @services =Service.select("services.id,services.service_name,services.service_description,service_price").joins("where services.creator_id=#{user_id}")
  
        format.html { render :index, notice: 'Service was successfully created.' }
        format.json { render :show, status: :created, location: @service }
      else
        format.html { render :new }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /services/1
  # PATCH/PUT /services/1.json
  def update
    user_id=session[:user_id]
    respond_to do |format|
      if @service.update(service_params)
        @services =Service.select("services.id,services.service_name,services.service_description,service_price").joins("where services.creator_id=#{user_id}")
        format.html { render :index, notice: 'Service was successfully updated.' }
        format.json { render :show, status: :ok, location: @service }
      else
        format.html { render :edit }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /services/1
  # DELETE /services/1.json
  def destroy
    user_id=session[:user_id]
    @service.destroy
    respond_to do |format|
       @services =Service.select("services.id,services.service_name,services.service_description,service_price").joins("where services.creator_id=#{user_id}")
      format.html { render :index, notice: 'Service was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_service
      @service = Service.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def service_params
      params.require(:service).permit(:service_name, :service_description, :service_price, :creator_id)
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
