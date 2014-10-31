begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
end

namespace :docker do
  task :build do
    `sudo docker build -t admiral . 1>&2`
  end

  task :spec do
    `sudo docker build -t admiral_test . 2>&1 > /dev/null && \
     sudo docker run -t admiral_test /root/.rbenv/shims/bundle exec rspec 1>&2`
  end
end
