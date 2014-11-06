module Admiral
  class Launcher

    def launch_instance(instance)
      set_launching_instance(instance)
      # TODO use fog to launch instance
    end

    def launching_instances
      Admiral.config['launching'].map(&:key)
    end

    def is_launching?(instance)
      launching_instances.include?(instance)
    end

    private

    def set_launching_instance(instance)
      val = {'instance' => instance, 'createdAt' => Time.now.to_s}.to_json
      Admiral.config.set("launching/#{instance}", value: val, ttl: 180)
    end

  end
end
