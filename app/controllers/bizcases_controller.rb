class BizcasesController < ApplicationController
  before_action :set_bizcase, only: [:show, :edit, :update, :destroy]
layout :products_layout
  # GET /bizcases
  # GET /bizcases.json
  def index
    #@bizcases = Bizcase.all
      current_user
    #@reports = Report.all
    @bizcases =Bizcase.select("bizcases.id,bizcases.bizcase_title,bizcases.bizcase_link,users.username")
    .joins("left join users on bizcases.bizcase_author=users.id where bizcases.bizcase_author=#{@current_user.id}")

  end

  # GET /bizcases/1
  # GET /bizcases/1.json
  def show
  end

  # GET /bizcases/new
  def new
    @bizcase = Bizcase.new
  end

  # GET /bizcases/1/edit
  def edit
  end

  # POST /bizcases
  # POST /bizcases.json
  def create
    @bizcase = Bizcase.new(bizcase_params)

    respond_to do |format|
      if @bizcase.save
        format.html { redirect_to @bizcase, notice: 'Bizcase was successfully created.' }
        format.json { render :show, status: :created, location: @bizcase }
      else
        format.html { render :new }
        format.json { render json: @bizcase.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bizcases/1
  # PATCH/PUT /bizcases/1.json
  def update
    respond_to do |format|
      if @bizcase.update(bizcase_params)
        format.html { redirect_to @bizcase, notice: 'Bizcase was successfully updated.' }
        format.json { render :show, status: :ok, location: @bizcase }
      else
        format.html { render :edit }
        format.json { render json: @bizcase.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bizcases/1
  # DELETE /bizcases/1.json
  def destroy
    @bizcase.destroy
    respond_to do |format|
      format.html { redirect_to bizcases_url, notice: 'Bizcase was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bizcase
      @bizcase = Bizcase.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bizcase_params
      params.require(:bizcase).permit(:bizcase_author, :bizcase_date, :bizcase_title, :bizcase_content, :bizcase_status, :bizcase_modified, :bizcase_type, :bizcase_link, :string)
    end
     def products_layout 
       return 'creator'
 end  
end
