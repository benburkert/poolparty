package :ruby do
  description 'Ruby Virtual Machine'
  # version '1.8.6'
  # source "ftp://ftp.ruby-lang.org/pub/ruby/1.8/ruby-#{version}-p111.tar.gz" # implicit :style => :gnu
  apt %w( ruby ruby1.8-dev )
  requires :ruby_dependencies
end

package :ruby_dependencies do
  description 'Ruby Virtual Machine Build Dependencies'
  apt %w( bison zlib1g-dev libssl-dev libreadline5-dev libncurses5-dev file )
end

package :rubygems do
  description 'Ruby Gems Package Management System'
  # version '1.0.1'
  # source "http://rubyforge.org/frs/download.php/29548/rubygems-#{version}.tgz" do
  #   custom_install 'ruby setup.rb'
  # end
  apt %w( rubygems )
  # post :install, "sed -i s/require\ 'rubygems'/require\ 'rubygems'\nrequire\ 'rubygems\/gem_runner'/g", "gem update --system", "gem sources -a http://gems.github.com"
  requires :ruby
end

package :required_gems do
  description "Pool party gem"
  gems %w( SQS aws-s3 amazon-ec2 auser-aska rake rcov auser-poolparty vlad --no-ri --no-rdoc)
  
  requires :rubygems
end