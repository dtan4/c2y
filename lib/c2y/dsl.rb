module C2y
  class DSL
    class << self
      def parse(path)
        self.new(path).result
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
      @result.update = Update.new(&block).result
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

    def unit(name, &block)
      @result.unit = Unit.new(name, &block).result
    end

    class Unit
      attr_reader :result

      def initialize(name, &block)
        @result = OpenStruct.new({
          name: name
        })

        instance_eval(&block)
      end

      private

      def command(unit_command)
        @result.command = unit_command.to_s
      end

      def content(unit_content)
        @result.content = unit_content
      end

      def enable(unit_enable)
        @result.enable = unit_enable
      end
    end
  end
end
