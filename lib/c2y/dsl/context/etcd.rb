module C2y
  class DSL::Context::Etcd
    attr_reader :result

    def initialize(name, &block)
      @result = OpenStruct.new(
        name: name
      )

      instance_eval(&block)
    end

    [:addr, :discovery, :peer_addr].each do |attr|
      define_method(attr) do |arg|
        @result.send("#{attr}=", arg)
      end

      private attr
    end
  end
end
