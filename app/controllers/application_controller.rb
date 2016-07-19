class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :count_unread_messages, if: -> { current_admin }

  def authenticate
    current_admin || render(nothing: true, status: :forbidden)
  end

  protected

  def count_unread_messages
    @contacts_count ||= Contact.count
  end
end
