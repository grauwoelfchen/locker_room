module LockerRoom
  class ApplicationController < ::ApplicationController
    protect_from_forgery :with => :exception

    before_filter :require_login
  end
end
