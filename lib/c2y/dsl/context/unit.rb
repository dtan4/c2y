module C2y
  class DSL::Context::Unit
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
