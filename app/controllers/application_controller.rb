class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def current_admin
    true
  end

  def authenticate
    if current_admin
      true
    else
      render nothing: true, status: :forbidden
    end
  end
end
