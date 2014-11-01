require 'fileutils'

namespace :docker do
  task :build do
    `sudo docker build -t admiral . 1>&2`
  end

  task :spec do
    FileUtils.cp 'Dockerfile', 'Dockerfile.bak'
    `sudo docker build -t admiral_test . 1>&2 && \
     sudo docker run -t admiral_test /sbin/my_init -- /root/.rbenv/shims/bundle exec rspec 1>&2`
  end
end

task default: ['docker:spec']
