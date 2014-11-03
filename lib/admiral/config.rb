module Admiral
  class Config
    NS = '/_admiral' # Etcd top level directory

    def [](key)
      node = Admiral.etcd.get("#{NS}/#{key}")
      if node.directory?
        return node.children
      else
        return try_to_parse(node.value)
      end
    end

    private

    def try_to_parse(maybe_json)
      JSON.parse(maybe_json)
      rescue
        return maybe_json
    end

  end
end
