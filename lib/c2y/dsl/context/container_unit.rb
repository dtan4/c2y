module C2y
  class DSL::Context::ContainerUnit
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

    def enable(unit_enable)
      @result.enable = unit_enable
    end

    def environments(unit_environments)
      @result.environments = unit_environments
    end

    def image(unit_image)
      @result.image = unit_image
    end

    def ports(unit_ports)
      @result.ports = unit_ports
    end

    def volumes(unit_volumes)
      @result.volumes = unit_volumes
    end
  end
end
