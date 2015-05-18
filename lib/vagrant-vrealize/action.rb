require "pathname"

require "vagrant/action/builder"

module VagrantPlugins
  module VRealize
    module Action
      # Include the built-in modules so we can use them as top-level things.
      include Vagrant::Action::Builtin

      # Actions Needed:
        # Halt, Destroy, SSH, PROVISION,

      # This action is called to bring the box up from nothing.
      def self.action_up
        Vagrant::Action::Builder.new.tap do |b|
          b.use HandleBox
          b.use ConfigValidate
          b.use ConnectVSphere
          b.use Call, IsCreated do |env, b2|
            if env[:result]
              b2.use MessageAlreadyCreated
              next
            end

            b2.use Clone
          end
          b.use Call, IsRunning do |env, b2|
            b2.use PowerOn unless env[:result]
          end
          b.use CloseVSphere
          b.use Provision
          b.use SyncedFolders
          b.use SetHostname
        end
      end

      # The autoload farm
      action_root = Pathname.new(File.expand_path("../action", __FILE__))
      autoload :ReadSSHInfo, action_root.join("read_ssh_info")
      autoload :ReadState, action_root.join("read_state")
    end
  end
end
