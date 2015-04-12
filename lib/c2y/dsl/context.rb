module C2y
  class DSL::Context
    def self.eval(path)
      self.new(path)
    end

    attr_reader :result

    def initialize(path)
      @result = OpenStruct.new(
        container_units: [],
        files: [],
        update: nil,
        units: [],
        users: [],
      )
      contents = open(path).read
      instance_eval(contents)
    end

    private

    def container_unit(name, &block)
      @result.container_units << ContainerUnit.new(name, &block).result
    end

    def etcd(name, &block)
      @result.etcd = Etcd.new(name, &block).result
    end

    def file(path, &block)
      @result.files << File.new(path, &block).result
    end

    def fleet(&block)
      @result.fleet = Fleet.new(&block).result
    end

    def update(&block)
      @result.update = Update.new(&block).result
    end

    def unit(name, &block)
      @result.units << Unit.new(name, &block).result
    end

    def user(name, &block)
      @result.users << User.new(name, &block).result
    end
  end
end
