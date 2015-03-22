module C2y
  class DSL
    def self.parse(path)
      Context.eval(path).result
    end
  end
end
