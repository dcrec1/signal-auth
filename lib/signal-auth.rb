ApplicationController.class_eval do
  before_filter :authenticate

  protected

  def authenticate
    authenticate_or_request_with_http_basic do |user_name, password|
      user_name.eql?(SignalAuth['user']) and password.eql?(SignalAuth['password'])
    end
  end
end

ProjectsController.class_eval do
  skip_before_filter :authenticate, :verify_authenticity_token, :only => [:build, :status]
end

BuildsController.class_eval do
  skip_before_filter :authenticate, :verify_authenticity_token
end
