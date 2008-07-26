=begin rdoc
  Array extensions
=end
require "enumerator"
class Array
  def to_os
    map {|a| a.to_os }
  end
  def collect_with_index &block
    self.enum_for(:each_with_index).collect &block
  end
  def runnable(quiet=true)
    self.join(" \n ").runnable(quiet)
  end
  def nice_runnable(quiet=true)
    self.join(" \n ").nice_runnable(quiet)
  end
end