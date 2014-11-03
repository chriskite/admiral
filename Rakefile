require 'fileutils'

namespace :docker do
  task :build do
    `sudo docker build -t admiral . 1>&2`
  end

  task :spec do
    FileUtils.cp 'Dockerfile', 'Dockerfile.bak'
    # enable the etcd runit
    `echo "ADD spec/etcd.sh /etc/service/etcd/run" >> Dockerfile`
    `sudo docker build -t admiral_test . 2>&1 > /dev/null && \
     sudo docker run -t admiral_test /sbin/my_init -- /root/.rbenv/shims/bundle exec rspec --color 1>&2`
    FileUtils.mv 'Dockerfile.bak', 'Dockerfile'
  end
end

task default: ['docker:spec']
