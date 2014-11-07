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
      repos = Admiral.config['github/repos'].map do |conf|
        data = JSON.parse(conf.value)
        RepoService.new(
          data['path'],
          data['dockerRegistryTag'],
          data['service'],
          data['numInstances']
        )
      end

      repos.each { |repo| repo.deploy_if_necessary }
    end

  end
end
