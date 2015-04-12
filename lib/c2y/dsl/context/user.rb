module C2y
  class DSL::Context::User
    attr_reader :result

    def initialize(name, &block)
      @result = OpenStruct.new(
        name: name
      )

      instance_eval(&block)
    end

    [:github, :groups].each do |attr|
      define_method(attr) do |arg|
        @result.send("#{attr}=", arg)
      end

      private attr
    end
  end
end
