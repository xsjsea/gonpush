class ReportsController < ApplicationController
  before_action :set_report, only: [:show, :edit, :update, :destroy]
  layout :products_layout
  # GET /reports
  # GET /reports.json
  def index
    current_user
    #@reports = Report.all
    @reports =Report.select("reports.report_title,reports.id,users.username,reports.report_source,reports.report_source")
    .joins("left join users on reports.report_author=users.id where reports.report_author=#{@current_user.id}")

  end

  # GET /reports/1
  # GET /reports/1.json
  def show
     current_user
    #@reports = Report.all
    @reports =Report.select("reports.report_title,reports.id,users.username")
    .joins("left join users on reports.report_author=users.id where reports.report_author=#{@current_user.id}")
 
  end

  # GET /reports/new
  def new
     current_user
    @report = Report.new
  end

  # GET /reports/1/edit
  def edit
     current_user
    @reports =Report.select("reports.report_title,reports.id,users.username")
    .joins("left join users on reports.report_author=users.id where reports.report_author=#{@current_user.id}")
 
  end

  # POST /reports
  # POST /reports.json
  def create
    @report = Report.new(report_params)

    respond_to do |format|
      if @report.save
        render reports_url
        #format.html { redirect_to @report, notice: 'Report was successfully created.' }
        #format.json { render :index, status: :created, location: @report }
      else
        format.html { render :new }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reports/1
  # PATCH/PUT /reports/1.json
  def update
    respond_to do |format|
      if @report.update(report_params)
        format.html { redirect_to @report, notice: 'Report was successfully updated.' }
        format.json { render :show, status: :ok, location: @report }
      else
        format.html { render :edit }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reports/1
  # DELETE /reports/1.json
  def destroy
    @report.destroy
    respond_to do |format|
      format.html { redirect_to reports_url, notice: 'Report was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_report
      logged_in_user
      @report = Report.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def report_params
      params.require(:report).permit(:report_author,:report_title, :report_source,:report_link   )
    end
     def products_layout 
       return 'creator'
 end  
end
