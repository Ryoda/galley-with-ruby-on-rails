class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_tags

  protected

	def authenticate_moderator!
		redirect_to root_path unless user_signed_in? && current_user.is_moderator?
	end
	def authenticate_admin!
		redirect_to root_path unless user_signed_in? && current_user.is_admin?
	end

  private

  def set_tags 
  	tags = Tag.all()
  end
end
