module C2y
  class Client
    COREOS_KEYS = [:etcd, :fleet, :flannel, :locksmith, :update, :units]

    def initialize
    end

    def convert(path)
      user_data = { coreos: {} }
      dsl_result = C2y::DSL.parse(path).to_h

      COREOS_KEYS.each do |key|
        user_data[:coreos][key] = dsl_result.delete(key) if dsl_result.has_key?(key)
      end

      user_data.merge!(dsl_result)

      <<-EOS.chomp
#cloud-config

#{walk(user_data.to_h).to_yaml.gsub(/\A---\n/, "")}
      EOS
    end

    private

    def convert_key(key)
      key.to_s.gsub("_", "-")
    end

    def empty_value?(value)
      value.nil? || (value.is_a?(Array) && value.empty?)
    end

    def walk(hash)
      hash.inject({}) do |result, (k, v)|
        result[convert_key(k)] =  case v
                                  when OpenStruct
                                    walk(v.to_h)
                                  when Hash
                                    walk(v)
                                  when Array
                                    v.map { |av| walk(av) }
                                  when Symbol
                                    v.to_s
                                  else
                                    v
                                  end
        result
      end.delete_if { |_, v| empty_value?(v) }
    end
  end
end
