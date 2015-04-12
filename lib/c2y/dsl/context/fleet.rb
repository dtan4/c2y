module C2y
  class DSL::Context::Fleet
    attr_reader :result

    def initialize(&block)
      @result = OpenStruct.new

      instance_eval(&block)
    end

    [:public_ip, :metadata].each do |attr|
      define_method(attr) do |arg|
        @result.send("#{attr}=", arg)
      end

      private attr
    end
  end
end
