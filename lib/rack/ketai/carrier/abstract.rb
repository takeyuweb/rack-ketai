module Rack::Ketai::Carrier
  class Abstract

    class << self
      @@filter_table = { }
      def filters=(obj)
        @@filter_table[self] = obj.is_a?(Array) ? obj : [obj]
      end

      def filters
        @@filter_table[self] ||= []
      end
    end

    def initialize(env)
      @env = env.clone
    end
    
    USER_AGENT_REGEXP = nil

    def filters
      self.class.filters
    end

    private
    def inbound_filter
    end

    def outbound_filter
    end

  end
end
