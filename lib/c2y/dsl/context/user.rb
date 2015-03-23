module C2y
  class DSL::Context::User
    attr_reader :result

    def initialize(name, &block)
      @result = OpenStruct.new(
        name: name
      )

      instance_eval(&block)
    end

    private

    def github(user_github)
      @result.github = user_github
    end

    def groups(user_groups)
      @result.groups = user_groups
    end
  end
end
