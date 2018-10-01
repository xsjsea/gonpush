class OrdersController < ApplicationController
  skip_before_action :verify_authenticity_token
  #before_action :set_order, only: [:show, :edit, :update, :destroy]
  layout :products_layout

  
  # GET /orders
  # GET /orders.json
  def index
    @user=User.find_by_id(session[:user_id])
     userId=@user.id
     if @user.usertype=="0"
        #@orders = Order.find_by_creator_id(@user.id)
         @orders =Order.select( "orders.status,campaigns.name,campaigns.budget,campaigns.start,orders.id, users.username,creator_exts.avatar").joins("LEFT JOIN campaigns  on orders.campaign_id=campaigns.id  LEFT JOIN users on orders.creator_id=users.id  LEFT JOIN creator_exts  on creator_exts.userid=users.id where orders.creator_id=#{userId}")

    else
        #@orders = Order.find_by_marketer_id(@user.id)
         @orders =Order.select("orders.status,campaigns.name,campaigns.budget,campaigns.start,orders.id,users.username,creator_exts.avatar").joins("LEFT JOIN campaigns  on orders.campaign_id=campaigns.id  LEFT JOIN users on orders.creator_id=users.id  left join creator_exts  on creator_exts.userid=users.id where orders.marketer_id=#{userId}")
    end
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
     @user=User.find_by_id(session[:user_id])
     orderId =  params[:orderId]
     @schedule= Schedule.select("flows.flow_order,flows.flow_name,schedules.workdays,schedules.ends_on").joins("LEFT JOIN flows on schedules.flow_id = flows.id
 where schedules.order_id=#{orderId}")
     @orderInfo=Order.select("campaigns.name,campaigns.description,campaigns.budget,campaigns.start,users.mobile,users.truename,users.address,orders.id").joins("LEFT JOIN campaigns  on orders.campaign_id=campaigns.id LEFT JOIN users on orders.creator_id=users.id where orders.id={orderId}")
 
  end

  # GET /orders/new
  def new
    #@order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
  @order = Order.new(allowed_params)
  curTime =Date.today
    if @order.save
      #generate schedules
      sql = ActiveRecord::Base.connection()        
      sql.insert "INSERT INTO schedules SET campaign_id='#{@order.campaign_id}', 
      flow_order=1,
      status='0',
      flow_id=1, 
      order_id='#{@order.id}',
      created_at='#{curTime}',updated_at='#{curTime}'"        
      sql.insert "INSERT INTO schedules SET campaign_id='#{@order.campaign_id}', 
      flow_order=2,
      status='0',
      flow_id=2, 
      order_id='#{@order.id}',
       created_at='#{curTime}',updated_at='#{curTime}'"    
      sql.insert "INSERT INTO schedules SET campaign_id='#{@order.campaign_id}', 
      flow_order=3,
      status='0',
      flow_id=3, 
      order_id='#{@order.id}',
       created_at='#{curTime}',updated_at='#{curTime}'"   
      sql.insert "INSERT INTO schedules SET campaign_id='#{@order.campaign_id}', 
      flow_order=4,
      status='0',
      flow_id=4, 
      order_id='#{@order.id}',
      created_at='#{curTime}',updated_at='#{curTime}'"   
      sql.insert "INSERT INTO schedules SET campaign_id='#{@order.campaign_id}', 
      flow_order=5,
      status='0',
      flow_id=5, 
      order_id='#{@order.id}',
      created_at='#{curTime}',updated_at='#{curTime}'"  

      # return New Order ID
      #
      render plain: @order.id
    else
      render :new
    end
  end

def showOrder
    @post=Post.new
    @user= User.find_by_id(session[:user_id]) 
    @order_id=params[:id]
    currentorder_id=params[:id]
    @schedules= Schedule.select("flows.flow_order,flows.flow_name,schedules.workdays,schedules.ends_on,schedules.id").joins("LEFT JOIN flows on schedules.flow_id = flows.id
    where schedules.order_id=#{currentorder_id}") 
     #@orders =Order.select( "orders.status,campaigns.name,campaigns.budget,campaigns.start,orders.id, users.username,creator_exts.avatar").joins("LEFT JOIN campaigns  on orders.campaign_id=campaigns.id  LEFT JOIN users on orders.creator_id=users.id  LEFT JOIN creator_exts  on creator_exts.userid=users.id where orders.id=#{parameter_id}")
     @orders=Order.select("campaigns.name,campaigns.description,campaigns.budget,campaigns.start,users.mobile,users.truename,users.address,orders.id").joins("LEFT JOIN campaigns  on orders.campaign_id=campaigns.id LEFT JOIN users on orders.creator_id=users.id where orders.id=#{currentorder_id}") 
     user_id=@user.id
     if(@user.usertype=='0')
     @unreadmessages=Message.select("count(*) total,step_order").joins("where order_id=#{currentorder_id} and user_id=#{user_id} and creatorstatus='1' group by order_id,step_order")
     elsif(@user.usertype=='1')
     @unreadmessages=Message.select("count(*) total,step_order").joins("where order_id=#{currentorder_id} and user_id=#{user_id} and marketerstatus='1' group by order_id,step_order")
     else
     @unreadmessages=Message.select("count(*) total,step_order").joins("where order_id=#{currentorder_id} and (marketerstatus='1' or  creatorstatus='1' ) and marketerstatus='1' group by order_id,step_order")
     end

 
     @steporder_1=Message.select("IFNULL(max(created_at),'') messagetime").joins("where order_id=#{currentorder_id} and step_order=1")
     @steporder_2=Message.select("IFNULL(max(created_at),'') messagetime").joins("where order_id=#{currentorder_id} and step_order=2")
     @steporder_3=Message.select("IFNULL(max(created_at),'') messagetime").joins("where order_id=#{currentorder_id} and step_order=3")
     @steporder_4=Message.select("IFNULL(max(created_at),'') messagetime").joins("where order_id=#{currentorder_id} and step_order=4")
     @steporder_5=Message.select("IFNULL(max(created_at),'') messagetime").joins("where order_id=#{currentorder_id} and step_order=5")
     render :layout => 'order_detail'

  end
def updatemessages
    order_id=params[:order_id]
    order_step=params[:order_step]
    @user= User.find_by_id(session[:user_id])
    sch = Message.find_by_order_id(order_id)
     if(@user.usertype=='0')
      sch.update_attribute('creatorstatus', '0')
     elsif(@user.usertype=='1')
       sch.update_attribute('marketerstatus', '0')
     end
      render plain: ''
  end
def updatepost
    @post=Post.new
    @user= User.find_by_id(session[:user_id])
    #order_id=params[:schedule_type]
    post_content=params[:post_content]
    schedule_id=params[:schedule_id]
    sch = Post.find_by_schedule_id(schedule_id)
    sch.update_attribute('post_content', post_content)
    render plain: post_content
  end
  def updatecomments
  curTime =Date.today
  content_comment=params[:content_comment]
  order_id =params[:order_id]
  user_id=session[:user_id]
  sql = ActiveRecord::Base.connection()     
      sql.insert "INSERT INTO comments SET comment_content='#{content_comment}', order_id='#{order_id}',user_id='#{user_id}',
      created_at='#{curTime}',updated_at='#{curTime}'" 
      render plain:content_comment
  end
  def updateSchedule
    @user=User.find_by_id(session[:user_id])
    parameter_id_1=params[:scheduleId_0]
    parameter_id_2=params[:scheduleId_1]
    parameter_id_3=params[:scheduleId_2]
    parameter_id_4=params[:scheduleId_3]
    parameter_id_5=params[:scheduleId_4]

    parameter_value_1=params[:input_1]
    parameter_value_2=params[:input_2]
    parameter_value_3=params[:input_3]
    parameter_value_4=params[:input_4]
    parameter_value_5=params[:input_5]
    sch = Schedule.find_by_id(parameter_id_1)
    sch.update_attribute('workdays', parameter_value_1)

    sch = Schedule.find_by_id(parameter_id_2)
    sch.update_attribute('workdays', parameter_value_2)

    sch = Schedule.find_by_id(parameter_id_3)
    sch.update_attribute('workdays', parameter_value_3)

    sch = Schedule.find_by_id(parameter_id_4)
    sch.update_attribute('workdays', parameter_value_4)

    sch = Schedule.find_by_id(parameter_id_5)
    sch.update_attribute('workdays', parameter_value_5) 
  end
  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    
    Schedule.find_by_order_id(params[:id])
    Order.find(params[:id]).destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  

    # Never trust parameters from the scary internet, only allow the white list through.
    def allowed_params
      params.permit(:campaign_id,:marketer_id,:creator_id,:status)
    end

   def products_layout 
    @user=User.find_by_id(session[:user_id]) 
    if @user.usertype=="0"
       return 'creator'
    else
      return 'marketer'
    end
   
 end  
  def order_detail_layout 
       return 'order_detail'
  end  
end
