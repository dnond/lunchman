class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  if !Rails.env.development?
    rescue_from Exception,                        with: :render_500
    rescue_from ActiveRecord::RecordNotFound,     with: :render_404
    rescue_from ActionController::RoutingError,   with: :render_404
  end

  def routing_error
    raise ActionController::RoutingError.new(params[:path])
  end

  def render_404
    render 'errors/error_404', status: 404
  end

  def render_500
    render 'errors/error_500', status: 500
  end

  def redirect_login_page_unless_logged_in
    redirect_to login_users_path  unless user_signed_in?
  end
end
