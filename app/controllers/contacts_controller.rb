class ContactsController < ApplicationController
  before_action :authenticate, except: [:new, :create]

  def index
    @contacts = Contact.order('created_at DESC')
  end

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      ContactMailer.contact_notification_email(@contact).deliver
      flash[:notice] = 'Created contact. Thank you!'
      redirect_to about_path
    else
      flash[:alert] = 'Cannot create new contact. Please inspect fields for errors.'
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @contact = Contact.find(params[:id])
    respond_to do |f|
      f.js do
        if @contact.update(params.require(:contact).permit(:unread))
          render nothing: true, status: :ok
        else
          render nothing: true, status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    @contact = Contact.find(params[:id])
    deleted = @contact.destroy
    respond_to do |f|
      if deleted
        f.html do
          flash[:notice] = 'Successfully deleted contact record'
          redirect_to contacts_path
        end
        f.js { render nothing: true, status: :ok }
      else
        f.html do
          flash[:alert] = "Cannot delete record: #{@contact.errors.inspect}"
          render :index
        end
        f.js { render nothing: true, status: :unprocessable_entity }
      end
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :reply, :content)
  end
end
