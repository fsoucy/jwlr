class ConversationsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user

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
      data.append([message[0], User.find(message[1]).name, message[2].to_time.to_i])
    end
    render json: data.to_json, status: 200
  end

  private
    
    def correct_user
      conversation = Conversation.find(params[:id])
      if !(current_user.id == conversation.first_user_id || current_user.id == conversation.second_user_id) 
        redirect_to root_url
      end
      return true
    end
end
