#require 'new_relic/agent/instrumentation/controller_instrumentation'
#require 'new_relic/agent/instrumentation/rails3/action_controller'
#require 'new_relic/agent/instrumentation/rails3/errors'
module Api
  class BaseController < ActionController::Base
    # minimum required controller functionality for rendering, proper mime-type
    # setting, and rescue_from functionality

    include Authenticable

    MODULES = [

      # ActionController::StrongParameters,
      # ActionController::Rendering,
      # ActionController::Renderers::All,
      # ActionController::ImplicitRender,
      # ActionController::RackDelegation,
      #ActionController::MimeResponds
      # AbstractController::Callbacks,
      # ActionController::Head,
      # ActionController::Rescue,
      # ActionController::Instrumentation,
      # ActiveRecord::Railties::ControllerRuntime,
      # NewRelic::Agent::Instrumentation::ControllerInstrumentation,
      # NewRelic::Agent::Instrumentation::Rails3::ActionController,
      # NewRelic::Agent::Instrumentation::Rails3::Errors,
      # ActionController::HttpAuthentication::Token::ControllerMethods

    ].each { |m| include m }

    # Class used to handle API response, and specific error code
    class InvalidAPIRequest < StandardError
      attr_reader :code

      # Public: constructor
      # message - message that gets shown in the response
      # code    - error code returned in the JSON response
      def initialize(message, code = 403)
        super(message)
        @code = code
      end
    end

    # Exception handler for invalid api requests
    rescue_from Exception do |ex|
      respond_to do |format|
        format.json do
          err_code = 403
          code = ex.respond_to?(:code) ? ex.code : 403

          resp_hash = { success: false, errors: [ex.message] }

          puts "API Response 403 is #{resp_hash.inspect} backtrace is #{ex.backtrace.inspect}" if code == 403
          resp_hash.merge!('stack_trace' => ex.backtrace) if Rails.env.development?

          render text: resp_hash.to_json, status: code
        end
      end
    end

    # Public: generates the json response
    # obj - object that contains the data sent in a request
    # returns - data in json format
    def build_data_object(obj)
      { success: true, data: obj }.to_json
    end

    # Public: generates error response
    # obj - object that contains the data sent in a request
    # returns json
    def build_error_object(obj)
      obj_errors = Array.new
      obj.errors.messages.each do |k,v|
        obj_errors <<  "#{k} #{v.join}"
      end
      { success: false, erros: obj_errors }.to_json
    end
  end
end