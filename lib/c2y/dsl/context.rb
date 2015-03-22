module C2y
  class DSL::Context
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

    def unit(name, &block)
      @result.unit = Unit.new(name, &block)
    end
  end
end
