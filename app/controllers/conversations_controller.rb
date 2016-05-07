class ConversationsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: [:show, :pull_messages]
  before_action :not_same_user, only: [:create]

  def show
    @conversation = Conversation.find(params[:id])
    last = @conversation.messages.count
    start = last - 50
    start = 0 if start < 0
    @messages = @conversation.messages[(start)..last]

    @msg = @conversation.messages.build
  end

  def pull_messages
    conversation = Conversation.find(params[:id])
    new_messages = conversation.messages.paginate(:page => params[:page], :per_page => 50).order("created_at DESC").pluck(:content, :sender_id, :created_at).reverse
    data = Array.new
    new_messages.each do |message|
      user = User.find(message[1])
      data.append([message[0], user.name, message[2].to_time.to_i, user.profile_picture(:thumbnail)])
    end
    render json: data.to_json, status: 200
  end

  def index
    @message_edit = true
    @conversations = Conversation.where("first_user_id = ? OR second_user_id = ?", current_user.id, current_user.id).order(updated_at: :desc)
  end

  private
    
    def correct_user
      conversation = Conversation.find(params[:id])
      if !(current_user.id == conversation.first_user_id || current_user.id == conversation.second_user_id) 
        redirect_to root_url
      end
      return true
    end

    def not_same_user
      if first_user.id == second_user.id
        flash[:warning] = "You can't start a conversation with yourself!"
        redirect_to current_user
      end
    end
end
