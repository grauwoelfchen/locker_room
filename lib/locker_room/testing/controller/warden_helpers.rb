module LockerRoom
  module Testing
    module Controller
module WardenHelpers
  def self.included(klass)
    klass.class_eval do
      setup :warden
    end
  end

  def process(*)
    catch_warden { super } || @response
  end

  def warden
    @warden ||= begin
      detect_manager = Rails.application.config.middleware.detect { |manager|
        manager.name == 'Warden::Manager'
      }.block
      manager = Warden::Manager.new(nil, &detect_manager)
      @request.env['warden'] = Warden::Proxy.new(@request.env, manager)
    end
  end

  protected

  def catch_warden(&block)
    result = catch(:warden, &block)

    if result.is_a?(Hash) &&
       !warden.custom_failure? &&
       !@controller.send(:performed?)
      result[:action] ||= :unauthenticated

      env = @controller.request.env
      env['PATH_INFO'] = "/#{result[:action]}"
      env['warden.options'] = result
      Warden::Manager._run_callbacks(:before_failure, env, result)

      status, headers, body = warden.config[:failure_app].call(env).to_a
      @controller.send(
        :render,
        :status       => status,
        :text         => body,
        :content_type => headers['Content-Type'],
        :location     => headers['Location']
      )
      nil
    else
      result
    end
  end
end
    end
  end
end
