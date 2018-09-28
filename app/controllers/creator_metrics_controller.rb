class CreatorMetricsController < ApplicationController
  before_action :set_creator_metric, only: [:show, :edit, :update, :destroy]
  layout :products_layout

   
 
  # GET /creator_metrics
  # GET /creator_metrics.json
  def index
   # @creator_metrics = CreatorMetric.all
    user_id=session[:user_id]
    CreatorMetric.select("creator_exts.avatar,creator_exts.category_id,users.sex,users.username,users.description,users.user_comment,creator_exts.tags_set").joins("left join creator_exts on users.id= creator_exts.userid where users.id=#{user_id})
  end

  # GET /creator_metrics/1
  # GET /creator_metrics/1.json
  def show
  end

  # GET /creator_metrics/new
  def new
    @creator_metric = CreatorMetric.new
  end

  # GET /creator_metrics/1/edit
  def edit
  end

  # POST /creator_metrics
  # POST /creator_metrics.json
  def create
    @creator_metric = CreatorMetric.new(creator_metric_params)

    respond_to do |format|
      if @creator_metric.save
        format.html { redirect_to @creator_metric, notice: 'Creator metric was successfully created.' }
        format.json { render :show, status: :created, location: @creator_metric }
      else
        format.html { render :new }
        format.json { render json: @creator_metric.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /creator_metrics/1
  # PATCH/PUT /creator_metrics/1.json
  def update
    respond_to do |format|
      if @creator_metric.update(creator_metric_params)
        format.html { redirect_to @creator_metric, notice: 'Creator metric was successfully updated.' }
        format.json { render :show, status: :ok, location: @creator_metric }
      else
        format.html { render :edit }
        format.json { render json: @creator_metric.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /creator_metrics/1
  # DELETE /creator_metrics/1.json
  def destroy
    @creator_metric.destroy
    respond_to do |format|
      format.html { redirect_to creator_metrics_url, notice: 'Creator metric was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_creator_metric
      @creator_metric = CreatorMetric.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def creator_metric_params
      params.require(:creator_metric).permit(:creator_id, :metric_id, :metric_name, :metric_value)
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
