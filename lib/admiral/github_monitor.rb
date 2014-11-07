module Admiral
  class GithubMonitor
    INTERVAL = 30

    def run!
      loop do
        check_repos
        sleep INTERVAL
      end
    end

    private

    def check_repos
      repos = Admiral.config['repos'].map do |conf|
        data = JSON.parse(conf.value)
        RepoService.new(
          data['url'],
          data['docker_registry_tag'],
          data['service'],
          data['num_instances']
        )
      end

      repos.each { |repo| repo.deploy_if_necessary }
    end

  end
end
