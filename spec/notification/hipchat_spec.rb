require 'spec_helper'

module Admiral
  module Notification
    describe Hipchat do

      let(:etcd) { Etcd.client }

      before(:each) do
        empty_etcd
      end

      after(:all) do
        empty_etcd
      end

      it "should send a notification using config from etcd" do
        # create config for a hipchat token and room
        etcd.set('/_admiral/notification/hipchat/token', value: 'foo')
        etcd.set('/_admiral/notification/hipchat/rooms/test_room', value: {name: 'Test Room'}.to_json)

        hipchat_mock = double()
        allow(::HipChat::Client).to receive(:new).and_return(hipchat_mock)
        room_mock = double()
        expect(room_mock).to receive(:send).with('Admiral', '[Fleet] test.service entered failed state', {notify: true, color: 'red'})
        expect(hipchat_mock).to receive(:[]).with('Test Room').and_return(room_mock)

        hipchat = Hipchat.new
        hipchat.notify('test.service', {})
      end
    end
  end
end
