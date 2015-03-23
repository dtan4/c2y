module C2y
  class DSL::Context
    def self.eval(path)
      self.new(path)
    end

    attr_reader :result

    def initialize(path)
      @result = OpenStruct.new
      contents = open(path).read
      instance_eval(contents)
    end

    private

    def container_unit(name, &block)
      @result.container_unit = ContainerUnit.new(name, &block).result
    end

    def update(&block)
      @result.update = Update.new(&block).result
    end

    def unit(name, &block)
      @result.unit = Unit.new(name, &block).result
    end
  end
end
