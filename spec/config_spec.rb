require 'spec_helper'

module Admiral
  describe Config do

    def empty_etcd
      `etcdctl rm --recursive #{Config::NS}`
    end

    before(:each) do
      empty_etcd
    end

    after(:all) do
      empty_etcd
    end

    describe "a method with the same name as a key" do
      it "should return that key" do

      end
    end

  end
end
