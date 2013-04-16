class ApplicationController < ActionController::Base

  def create_user
    if current_user.nil?
    @current_user = User.find_by_email("#{request.remote_ip}@localhost.com")
    current_user = @current_user
      if @current_user.nil?
        @current_user = User.new(email: "#{request.remote_ip}@localhost.com", password: 123456)
        @current_user.save!
      else
        @current_user = @current_user
      end
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "Access denied!"
    redirect_to root_url
  end
  protect_from_forgery
end
