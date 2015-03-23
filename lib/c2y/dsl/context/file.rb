module C2y
  class DSL::Context::File
    attr_reader :result

    def initialize(path, &block)
      @result = OpenStruct.new(
        path: path
      )

      instance_eval(&block)
    end

    private

    def content(file_content)
      @result.content = file_content
    end

    def owner(file_owner)
      @result.owner = file_owner
    end

    def permissions(file_permissions)
      @result.permissions = file_permissions
    end
  end
end
