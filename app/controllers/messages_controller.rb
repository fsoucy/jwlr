class MessagesController < ApplicationController
  before_action :logged_in_user
  
  def create
    other_id = params[:message][:other_id].to_i
    user_id = params[:message][:sender_id].to_i
    if user_id == other_id
      flash[:warning] = "You can't talk to yourself"
      redirect_to current_user
      return
    end
    if current_user.id == user_id
      conversation = Conversation.where("(first_user_id=? or first_user_id=?) AND (second_user_id=? or second_user_id=?)", user_id, other_id, user_id, other_id)
      if conversation.first.nil?
        convo = Conversation.new(first_user_id: other_id, second_user_id: user_id)
        convo.save
        new_notification(convo.first_user.name + " has opened a conversation with you.", convo.second_user, conversations_path(id: convo.id))
      else
        convo = conversation.first
      end
      params[:message][:content] = params[:message][:content].squish
      @message = convo.messages.build(message_params)
      if @message.content.length > 0
        @message.save
        convo.save
      end
      if params[:message][:on_deals]
        redirect_to Deal.find(params[:message][:deal_id])
      else
        redirect_to(controller: 'conversations', action: 'index', id: convo.id)
      end
    else
      redirect_to root_url
    end
  end

  private
  def message_params
    params.require(:message).permit(:sender_id, :content)
  end

end

