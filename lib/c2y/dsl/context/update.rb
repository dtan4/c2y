module C2y
  class DSL::Context::Update
    attr_reader :result

    def initialize(&block)
      @result = OpenStruct.new({
        group: "alpha",
        reboot_strategy: "off",
      })

      instance_eval(&block)
    end

    [:group, :reboot_strategy].each do |attr|
      define_method(attr) do |arg|
        @result.send("#{attr}=", arg)
      end

      private attr
    end
  end
end
