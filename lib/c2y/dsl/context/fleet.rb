module C2y
  class DSL::Context::Fleet
    attr_reader :result

    def initialize(&block)
      @result = OpenStruct.new

      instance_eval(&block)
    end

    private

    def public_ip(fleet_public_ip)
      @result.public_ip = fleet_public_ip
    end

    def metadata(fleet_metadata)
      @result.metadata = fleet_metadata
    end
  end
end
