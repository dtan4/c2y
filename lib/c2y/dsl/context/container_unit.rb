module C2y
  class DSL::Context::ContainerUnit
    attr_reader :result

    def initialize(name, &block)
      @result = OpenStruct.new({
        name: name
      })

      instance_eval(&block)
    end

    [:command, :enable, :environments, :image, :ports, :volumes].each do |attr|
      define_method(attr) do |arg|
        @result.send("#{attr}=", arg)
      end

      private attr
    end
  end
end
