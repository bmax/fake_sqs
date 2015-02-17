require 'sinatra/base'

module FakeSQS
  class WebInterface < Sinatra::Base

    configure do
      use FakeSQS::CatchErrors, response: ErrorResponse
    end

    helpers do

      def action
        params.fetch("Action")
      end

    end

    get "/" do
      200
    end

    delete "/" do
      settings.api.reset
      200
    end

    put "/" do
      settings.api.expire
      200
    end

    post "/" do
      puts request.env["HTTP_HOST"]
      puts "Received request to / with action #{action} and params #{params}"


      params['logger'] = logger
      if params['QueueUrl']
        queue = URI.parse(params['QueueUrl']).path.gsub(/\//, '')
        return settings.api.call(action, queue, params) unless queue.empty?
      end

      # TODO: this better
      if action == "GetQueueUrl"
        params[:server_config] = {
          host: request.env["SERVER_NAME"],
          port: request.env["SERVER_PORT"]
        }
      end

      settings.api.call(action, params)
    end

    post "/:queue" do |queue|
      puts "Received request to /:queue with action #{action} and params #{params}"

      settings.api.call(action, queue, params)
    end

  end
end
