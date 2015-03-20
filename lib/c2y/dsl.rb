module C2y
  class DSL
    class << self
      def define(path)
        self.new(path)
      end
    end

    attr_reader :result

    def initialize(path)
      @result = OpenStruct.new
      contents = open(path).read
      instance_eval(contents)
    end

    private

    def update(&block)
      @result.update = Update.new(&block)
    end

    class Update
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
end
