require "vagrant"

module VagrantPlugins
  module VRealize
    module Errors
      class VagrantVRealizeError < Vagrant::Errors::VagrantError
        error_namespace("vagrant_vrealize.errors")
      end

      class RestClientError < VagrantAWSError
        error_key(:rest_client_error)
      end
    end
  end
end
