class FaqsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user_store, only: [:create, :new]
  before_action :correct_user_faq, only: [:update, :edit, :destroy]  

  def create
    @faq = current_user.stores.find_by(id: params[:id]).faqs.build(faq_params)
    if @faq.save
      flash[:success] = "FAQ created!"
      redirect_to @faq.store
    else
      render 'new'
    end
  end

  def new
    @faq = Faq.new
  end

  def update
    @faq = Faq.find(params[:id])
    if @faq.update_attributes(faq_params)
      flash[:success] = "FAQ updated"
      redirect_to @faq.store
    else
      render 'edit'
    end
  end
  
  def edit
    @faq = Faq.find(params[:id])
  end

  def destroy
    @faq = Faq.find_by(id: params[:id])
    @faq.destroy
    flash[:success] = "FAQ deleted"
    redirect_to @faq.store
  end

  private
    
    def faq_params
      params.require(:faq).permit(:question, :answer)
    end

    def logged_in_user
      redirect_to root_url if !logged_in?
    end

    def correct_user_store
      @store = current_user.stores.find_by(id: params[:id])
      redirect_to root_url if @store.nil?
    end

    def correct_user_faq
      @faq = Faq.find_by(id: params[:id])
      redirect_to root_url if @faq.store.user != current_user
    end

end
