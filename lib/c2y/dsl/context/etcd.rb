module C2y
  class DSL::Context::Etcd
    attr_reader :result

    def initialize(name, &block)
      @result = OpenStruct.new(
        name: name
      )

      instance_eval(&block)
    end

    private

    def addr(etcd_addr)
      @result.addr = etcd_addr
    end

    def discovery(etcd_discovery)
      @result.discovery = etcd_discovery
    end

    def peer_addr(etcd_peer_addr)
      @result.peer_addr = etcd_peer_addr
    end
  end
end
