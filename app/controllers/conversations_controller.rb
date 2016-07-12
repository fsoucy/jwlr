class ConversationsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: [:show, :pull_messages], except: [:conversations_index]
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
    new_messages = conversation.messages.paginate(:page => params[:page], :per_page => 50).order("created_at DESC").pluck(:content, :sender_id, :created_at, :product_id).reverse
    data = Array.new
    new_messages.each do |message|
      user = User.find(message[1])
      prod_id = 0
      if !message[3].nil?
        prod_id = message[3]
      end
      data.append([message[0], user.name, message[2].to_time.to_i, user.profile_picture(:thumbnail), prod_id])
    end
    render json: data.to_json, status: 200
  end

  def index
    @message_edit = true   
    conversations_group = Array.new
    current_user.groups.each do |group|
      conversations_group.append(group.conversations.first)
    end
    conversations_normal = Conversation.where('second_user_id = ? OR first_user_id = ?', current_user.id, current_user.id).order(updated_at: :desc).all
    @conversations = conversations_group + conversations_normal
    @conversations = @conversations.sort_by{ |convo| -convo.updated_at.to_time.to_i }
    pertinent_notifications = Notification.where("url=? AND user_id=?", request.original_url, current_user.id)
    pertinent_notifications.each do |n|
      n.read = true
      n.viewed = true
      n.save
    end
  end

  def conversations_index
    conversations_group = Array.new
    current_user.groups.each do |group|
      conversations_group.append(group.conversations.first)
    end
    conversations_normal = Conversation.where('second_user_id = ? OR first_user_id = ?', current_user.id, current_user.id).order(updated_at: :desc).all
    @conversations = conversations_group + conversations_normal
    @conversations = @conversations.sort_by{ |convo| -convo.updated_at.to_time.to_i }
  end

  private
    
    def correct_user
      conversation = Conversation.find(params[:id])
      if !conversation.group.nil?
        if conversation.group.user_member?(current_user)
          return true
        end
      end
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
