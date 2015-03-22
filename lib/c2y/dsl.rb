module C2y
  class DSL
    def self.parse(path)
      Context.new(path).result
    end
  end
end
