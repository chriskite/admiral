require 'spec_helper'

module Admiral
  describe Config do

    let(:state_monitor) { StateMonitor.new }
    let(:etcd) { Etcd.client }

    before(:each) do
      empty_etcd
    end

    after(:all) do
      empty_etcd
    end

    describe "#failed_states" do
      let(:test_data) do
        JSON.parse('{"loadState":"loaded","activeState":"active","subState":"running","machineState":{"ID":"a2d77760c3ed4f2f9bc38b9f08332ac4","PublicIP":"","Metadata":null,"Version":""},"unitHash":"2e4b6aa807c3b569388916403141860689653f7b"}')
      end

      it "should yield states which have changed to failed" do
        test_key = "test.service"
        etcd.set("#{StateMonitor::STATE_KEY}/#{test_key}", value: test_data.to_json) 
        expect{ |b| state_monitor.failed_states(&b) }.not_to yield_control

        # set the fleet unit state to failed
        test_data['subState'] = 'failed'
        etcd.set("#{StateMonitor::STATE_KEY}/test.service", value: test_data.to_json) 

        expect { |b| state_monitor.failed_states(&b) }.to yield_with_args(test_key, test_data)
      end
    end

  end
end
