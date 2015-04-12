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

    private

    def group(channel)
      @result.group = channel.to_s
    end

    def reboot_strategy(strategy)
      @result.reboot_strategy = strategy.to_s
    end
  end
end
