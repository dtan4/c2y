module C2y
  class DSL::Context::File
    attr_reader :result

    def initialize(path, &block)
      @result = OpenStruct.new(
        path: path
      )

      instance_eval(&block)
    end

    [:content, :owner, :permissions].each do |attr|
      define_method(attr) do |arg|
        @result.send("#{attr}=", arg)
      end

      private attr
    end
  end
end
