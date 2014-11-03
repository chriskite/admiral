module Admiral
  class StateMonitor
    STATE_KEY = '/_coreos.com/fleet/state'
    
    def initialize
      @states = {}
    end

    # Loads all service states from etcd
    # Yields states which have changed to failed
    def failed_states
      new_states = Admiral.etcd.get(STATE_KEY).children
      new_states.each do |service_state|
        service_data = JSON.parse(service_state.value)
        was_ok = @states[service_state.key]['subState'] != 'failed' rescue true
        is_failed = service_data['subState'] == 'failed'

        yield service_data if was_ok && is_failed

        @states[service_state.key] = service_data 
      end
    end

  end
end
