module Admiral
  class RepoService
    
    def initialize(github_path, docker_registry_tag, service_name, num_instances)
      @github_path = github_path
      @docker_registry_tag = docker_registry_tag
      @service_name = service_name
      @github_token = Admiral.config['github/token']
      FileUtils.mkdir_p(checkout_path)
    end

    def deploy_if_necessary
      build_and_deploy_if_new_tag 
      scale_to_num_instances
    end

    private

    def scale_to_num_instances
    end

    def build_and_deploy_if_new_tag
      old_tag = get_tag
      pull
      if get_tag != old_tag
        build
        push
        deploy
      end
    end

    def checkout_path
      "/tmp/admiral/#{@service_name}"
    end
    
    def get_tag
      `cd #{checkout_path} && git describe`
    end

    def build
      `docker build -t #{@docker_registry_tag} #{@checkout_path}`
    end

    def push
      `docker push #{@docker_registry_tag}`
    end
    
    def pull
      `cd #{checkout_path} && git fetch origin && git pull --tags origin master`
    end

    def clone
      `git clone #{github_url} #{checkout_path}`
    end

    def deploy

    end

    def github_url
      "https://#{@github_token}:@github.com/#{@github_path}"
    end

  end
end
