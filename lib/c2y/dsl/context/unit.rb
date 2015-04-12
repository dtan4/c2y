module C2y
  class DSL::Context::Unit
    attr_reader :result

    def initialize(name, &block)
      @result = OpenStruct.new({
        name: name
      })

      instance_eval(&block)
    end

    [:command, :content, :enable].each do |attr|
      define_method(attr) do |arg|
        @result.send("#{attr}=", arg)
      end

      private attr
    end
  end
end
