require File.dirname(__FILE__) + "/resource"

module PoolParty
  module DefinableResource
    def define_resource(name, &block)
      symc = "#{name}".classify
      klass = symc.class_constant(PoolParty::Resources::CustomResource, {:preserve => true}, &block)
      # unless Object.const_defined?(symc)
      #   Kernel.module_eval <<-EOE
      #     class #{symc} < PoolParty::Resources::CustomResource
      #     end
      #   EOE
      #   if block
      #     symc.constantize.module_eval &block
      #     PoolParty::Resources.module_eval &block
      #   end
      # end
      # symc.constantize
      klass
    end    
  end

  module Resources
    
    def call_function(str, opts={}, &block)
      puts "call_function: #{str}"
      returning PoolParty::Resources::CallFunction.new(str, opts, &block) do |o|
        resource(:call_function) << o
      end
    end
                
    # Resources for function call
    class CallFunction < Resource
      def initialize(str="", opts={}, &block)
        @str = str
        super(opts, &block)
      end
      def to_string(prev="")
        returning Array.new do |arr|
          arr << "#{prev}#{@str}"
        end.join("\n")
      end
    end
    
    class CustomResource < Resource
      def initialize(name=:custom_method, opts={}, &block)
        @name = name
        super(opts, &block)
      end
      
      def self.inherited(subclass)
        super(subclass)
      end
      
      def self.custom_function(str)
        custom_functions << str
      end
      
      def self.custom_function(str)
        custom_functions << str
      end      
      def self.custom_functions
        @custom_functions ||= []
      end
      def custom_function(str)
        self.class.custom_functions << str
      end
      
      def self.custom_functions_to_string(prev="")
        returning Array.new do |output|
          custom_functions.each do |function_string|
            output << "#{prev}\t#{function_string}"
          end
        end.join("\n")
      end      
      
      def to_string(prev="")
        returning Array.new do |output|
          output << "#{prev} # Custom Functions\n"
          output << self.class.custom_functions_to_string(prev)
        end.join("\n")        
      end
    end
    
    # Stub methods
    # TODO: Find a better solution
    def custom_function(*args, &block)
    end
    def self.custom_function(*args, &block)
    end      
    
  end    
end