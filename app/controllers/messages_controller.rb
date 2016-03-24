class MessagesController < ApplicationController
  def create
    other_id = params[:message][:other_id]
    user_id = params[:message][:sender_id]
    conversation = Conversation.where("first_user_id=? or first_user_id=? AND second_user_id=? or second_user_id=?", user_id, other_id, user_id, other_id)
    if conversation.first.nil?
      convo = Conversation.new(first_user_id: other_id, second_user_id: user_id)
      convo.save
    else
      convo = conversation.first
    end
    @message = convo.messages.build(message_params)
    @message.save
    if params[:message][:on_deals]
      redirect_to Deal.find(params[:message][:deal_id])
    else
      redirect_to @message.conversation
    end
  end

  private
  def message_params
    params.require(:message).permit(:sender_id, :content)
  end
end
