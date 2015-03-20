module C2y
  class DSL
    class << self
      def define(path)
        self.new(path)
      end
    end

    def initialize(path)
      @result = OpenStruct.new
      contents = open(path).read
      instance_eval(contents)
    end
  end
end
