require 'templater'
module PoolParty
  module Generators
    extend Templater::Manifold
  end
end

path = File.join(File.dirname(__FILE__))

require path / "plugin"


Templater::Discovery.discover!("pool-gen")