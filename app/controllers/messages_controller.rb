class MessagesController < ApplicationController
  before_action :logged_in_user
  
  def create
    if params[:message][:group_id] == ""
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
          conversation = Conversation.new(first_user_id: other_id, second_user_id: user_id)
          conversation.save
          new_notification(conversation.first_user.name + " has opened a conversation with you.", conversation.second_user, conversations_path(id: conversation.id))
        else
          conversation = conversation.first
        end
        params[:message][:content] = params[:message][:content].squish
        @message = conversation.messages.build(message_params)
        if @message.content.length > 0
          @message.save
          conversation.update_attribute(:updated_at, Time.now)
          conversation.save
        end
        if params[:message][:on_deals]
          redirect_to Deal.find(params[:message][:deal_id])
        else
          redirect_to(controller: 'conversations', action: 'index', id: conversation.id)
        end
      else
        redirect_to root_url
      end
    else
      user_id = params[:message][:sender_id].to_i
      if current_user.id == user_id
        group = Group.find(params[:message][:group_id].to_i)
        if group.user_member?(current_user)
          message = group.conversations.first.messages.build(sender_id: user_id, content:  params[:message][:content].squish)
          message.save
          group.conversations.first.update_attribute(:updated_at, Time.now)
          group.conversations.first.save
        else
          redirect_to root_url
        end
      else
        redirect_to root_url
      end
    end
  end

  private
  def message_params
    params.require(:message).permit(:sender_id, :content, :product_id)
  end

end

