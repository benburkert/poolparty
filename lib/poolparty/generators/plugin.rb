module PoolParty
  module Generators
    class PoolPartyPluginGenerator < Templater::Generator

      def self.source_root
        File.join(File.dirname(__FILE__), 'templates', 'application', 'poolparty_plugin')
      end

      option :testing_framework, :default => :rspec, :desc => 'Testing framework to use (one of: rspec, test_unit)'
      option :bin, :as => :boolean # TODO: explain this

      desc <<-DESC
        This generates a fresh PoolParty plugin.
      DESC

      glob!

      first_argument :name, :required => true, :desc => "Plugin name"

      def destination_root
        File.join(@destination_root, name)
      end
    end

    add :plugin, PoolPartyPluginGenerator
  end
end