module Admiral
  class Config

    def [](key)
      node = Admiral.etcd.get("#{Admiral::NS}/#{key}")
      if node.directory?
        return node.children
      else
        return try_to_parse(node.value)
      end
    end

    def []=(key, val)
      Admiral.etcd.set("#{Admiral::NS}/#{key}", value: val)
    end

    def set(key, val, opts)
      Admiral.etcd.set("#{Admiral::NS}/#{key}", opts)
    end

    private

    def try_to_parse(maybe_json)
      JSON.parse(maybe_json)
      rescue
        return maybe_json
    end

  end
end
