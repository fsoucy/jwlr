class ConversationsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user

  def show
    @conversation = Conversation.find(params[:id])
    @messages = @conversation.messages

    @msg = @conversation.messages.build
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
