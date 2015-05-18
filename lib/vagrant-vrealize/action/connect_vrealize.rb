require "log4r"
require "rest-client"

module VagrantPlugins
  module VRealize
    module Action
      # This action connects to vRealize, verifies credentials work (or token if passed in) and
      # puts the vRealize connection object into the `:vrealize_compute` key
      # in the environment.
      class ConnectvRealize
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant_vrealize::action::connect_vrealize")
        end

        def call(env)
          config = env[:machine].provider_config

          if config.authorization_token.nil?
            # Get an authorization_token
            @logger.info("Getting an authorization token")

            request_auth_token_body = "{
              \"username\": \"#{config.username}\",
              \"password\": \"#{config.password}\",
              \"tenant\":\"#{config.tenant}
            }"

            URL = "#{config.host}/identity/api/tokens"
            resource = RestClient::Resource.new(URL,:content_type => :json, :accept => :json)
            response = resource.post(request_auth_token_body)
            env[:authorization_token] = response.id
            @logger.info("New authorization token created: #{env[:authorization_token]}")

          #else
            # Make sure the authorization token is valid

          end

          #Now we should be able to create a connection and store it as vrealize_compute
          @logger.info("Connecting to vRealize...")
          URL = "#{config.host}/catalog-service/api/consumer"
          env[:vrealize_compute] = RestClient::Resource.new(URL,:content_type => :json, :accept => :json, :Authorization => "Bearer #{env[:authorization_token]}")

          @app.call(env)
        end
      end
    end
  end
end
