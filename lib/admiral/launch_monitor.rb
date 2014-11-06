module Admiral
  class LaunchMonitor
    INTERVAL = 5 # seconds between polls

    def initialize
      @launcher = Launcher.new
    end

    def run!
      loop do
        launch_nessary_instances
        sleep INTERVAL
      end
    end

    private

    def launch_necessary_instances
      pending_units.each do |unit|
        if !!unit.instance && !@launcher.is_launching?(unit.instance)
          @launcher.launch_instance(unit.instance)
        end
      end
    end

    def pending_units
      (job_names - state_names).map do |name|
        data = Admiral.etcd.get("#{Admiral::FLEET_NS}/job/#{name}/object")
        Unit.new(data)
      end
    end

    def job_names
      list_fleet_dir('job')
    end

    def state_names
      list_fleet_dir('state')
    end

    def list_fleet_dir(dir)
      Admiral.etcd.ls("#{Admiral::FLEET_NS}/#{dir}").map do |key|
        key.split('/').last
      end
    end

  end
end
