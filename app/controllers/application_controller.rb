class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def authenticate
    current_admin || render(nothing: true, status: :forbidden)
  end
end
