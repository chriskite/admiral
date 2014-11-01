module Admiral
  class Config
    NS = '/_admiral' # Etcd top level directory

    def [](key)
      node = Admiral.etcd.get("#{NS}/#{key}")
      if node.directory?
        return node.children
      else
        return node.value
      end
    end

  end
end
