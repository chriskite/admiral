module Admiral
  class StateMonitor
    STATE_KEY = "#{Admiral::FLEET_NS}/state"
    INTERVAL = 5 # seconds between polls
    
    def initialize
      @states = {}
    end

    def run!
      loop do
        failed_states { |name, state| send_notifications(name, state) }
        sleep INTERVAL
      end
    end

    # Loads all service states from etcd
    # Yields states which have changed to failed
    def failed_states
      old_states = @states
      @states = {}

      new_states = Admiral.etcd.get(STATE_KEY).children
      new_states.each do |service_state|
        service_key = service_state.key.split('/').last
        service_data = JSON.parse(service_state.value)
        was_ok = old_states[service_key]['subState'] != 'failed' rescue true
        is_failed = service_data['subState'] == 'failed'

        yield service_key, service_data if was_ok && is_failed

        @states[service_key] = service_data 
      end
    end

    private

    def send_notifications(name, state)
      # create notification classes from config
      Admiral.config['notification'].each do |notification_config|
        NotificationFactory.create(notification_config).notify(name, state) 
      end
    end

  end
end
