require "vagrant"

module VagrantPlugins
  module VRealize
    class Config < Vagrant.plugin("2", :config)
      # The URL to the host where the vRealize API can be accessed
      #
      # @return [String]
      attr_accessor :host

      # The username used to access the vRealize API
      #
      # @return [String]
      attr_accessor :username

      # The password used to access the vRealize API
      #
      # @return [String]
      attr_accessor :password

      # Instead of passing in a username and password, an
      # authorization_token can be passed in to bypass the request
      # for a new authorization_token
      #
      # @return [String]
      attr_accessor :authorization_token

      # The name of the tenant to use when requesting an
      # authorization token
      #
      # @return [String]
      attr_accessor :tenant

      # The name of the catalog item being requested
      #
      # @return [String]
      attr_accessor :catalog_item_name

      # The description used for the catalog item request
      #
      # @return [String]
      attr_accessor :request_description


      def initialize(region_specific=false)
        @host                 = UNSET_VALUE
        @username             = UNSET_VALUE
        @password             = UNSET_VALUE
        @authorization_token  = UNSET_VALUE
        @tenant               = UNSET_VALUE
        @catalog_item_name    = UNSET_VALUE
        @request_description  = UNSET_VALUE

        # Internal state (prefix with __ so they aren't automatically
        # merged)
        @__finalized = false

      end


      def finalize!
        @host = nil if @host == UNSET_VALUE
        @username = nil if @username == UNSET_VALUE
        @password = nil if @password == UNSET_VALUE
        @authorization_token = nil if @authorization_token == UNSET_VALUE
        @tenant = nil if @tenant == UNSET_VALUE
        @catalog_item_name = nil if @catalog_item_name == UNSET_VALUE
        @request_description = "Default Request Description" if @request_description == UNSET_VALUE

        @__finalized = true
      end

      def validate(machine)
        errors = _detected_errors

        errors << I18n.t("vagrant_vrealize.config.host_required") if @host.nil?
        errors << I18n.t("vagrant_vrealize.config.username_required") if @username.nil?
        # Need to do some more work with the password config.. Should be able to type it in or pass it into the config
        errors << I18n.t("vagrant_vrealize.config.catalog_item_name_required") if @catalog_item_name.nil?

        { "vRealize Provider" => errors }
      end
    end
  end
end
