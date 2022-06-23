class MessagesController < ApplicationController
  before_action :authenticate_user, except: [:index, :show]
  before_action :set_message, only: [:show, :update, :destroy]
  before_action :check_ownership, only: [:update, :destroy]

  # GET /messages
  def index
    # changed from Message.all to Message.order... so we can render the other we want it displayed
   @messages = []

   if (params[:username])
    Message.find_by_user(params[:username]).order('updated_at DESC') do |message|
      @messages << message.transform_message
    end
   else
    Message.order("updated_at DESC").each do |message|
      @messages << message.transform_message
    end
   end

   if @messages.count == 0
    render json: {error: 'Messages not found'}
   else
    render json: @messages
   end
  end

  # GET messages for specific users - searches specific users messages
  def user_messages
    @messages = []
    Message.find_by_user(params[:username]).order('updated_at DESC') do |message|
      @messages << message.transform_message
    end
    render json: @messages
  end

  # GET /messages/1
  def show
    if @message 
      render json: @message.transform_message
    else
      render json: {"error": "Message not found, wrong ID"}, status: :not_found
    end
  end

  # GET messages for current user
  def my_messages
    @messages = []

    current_user.messages.order("updated_at DESC").each do |message|
      @messages << message.transform_message
    end
    render json: @messages
  end

  # POST /messages
  def create
    # @message = Message.new(message_params)
    @message = current_user.messages.create(message_params)
    if @message.save
      # adding the transform_message to @message will render the data as desired
      render json: @message.transform_message, status: :created #, location: @message
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /messages/1
  def update
    if @message.update(message_params)
      render json: @message.transform_message
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  # DELETE /messages/1
  def destroy
    @message.destroy
  end

  private

  def check_ownership
    # if the user is an admin, it will skip the onership check
    if !(current_user is_admin || current_user.id == @message.user.id)
    # if !current_user.is_admin
    #   if current_user.id != @message.user.id
        render json: {error: "Unauthorised to perform this action"}
      # end
    end
  end
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find_by_id(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def message_params
      params.require(:message).permit(:text)
    end
end
