module Admiral
  class Config
    NS = '/_admiral' # Etcd top level directory

    def github_oauth_token
      Admiral.etcd.get("#{NS}/github_oauth_token").value
    end

    def repos
      Admiral.etcd.get("#{NS}/repos")
    end

  end
end
