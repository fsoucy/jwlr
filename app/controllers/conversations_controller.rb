class ConversationsController < ApplicationController
  def show
    @conversation = Conversation.find(params[:id])
    @messages = @conversation.messages

    @msg = @conversation.messages.build
  end
end
