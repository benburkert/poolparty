=begin rdoc
  Basic, add an alias_method to the object class
  Add returning to the object
=end
class Object
  def my_methods
    self.methods.sort - (self.class.methods + self.class.superclass.methods)
  end
  def to_os
    self
  end  
  def alias_method(new_id, original_id)
    original = self.method(original_id).to_proc
    define_method(new_id){|*args| original.call(*args)}
  end
  def with_options(opts={}, parent=self, &block)
    @p = parent.clone
    @p.options.merge!(opts)
    @p.instance_eval &block if block
  end  
  def returning(receiver)
    yield receiver
    receiver
  end
  def extended(&block)
    block.in_context(self).call
    self
  end
  def to_option_string
    case self.class
    when String
      self.to_option_string
    when Array
      self.each {|a| a.to_option_string }.join(" ")
    else
      "#{self}"
    end
  end
  def block_instance_eval(*args, &block)
    return instance_eval(*args,&block) unless block_given? && !block.arity.zero?
    old_method = (self.class.instance_method(:__) rescue nil)
    self.class.send(:define_method, :__, &block)
    block_method = self.class.instance_method(:__)
    if old_method
      self.class.send(:define_method, :__, old_method)
    else
      self.class.send(:remove_method, :__)
    end
    block_method.bind(self).call(*args)
  end
  def meta_def name, &blk
    (class << self; self; end).instance_eval { define_method name, &blk }
  end
end