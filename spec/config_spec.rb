require 'spec_helper'

module Admiral
  describe Config do

    let(:config) { Config.new }

    before(:each) do
      empty_etcd
    end

    after(:all) do
      empty_etcd
    end

    describe "#[]" do
      context "when the key doesn't exist" do
        it "should raise an error" do
          expect{config['foo']}.to raise_error(Etcd::KeyNotFound)
        end
      end

      context "when the key exists" do
        context "and is not a directory" do
          context "and is not JSON" do
            it "should return that key's value" do
              `etcdctl set #{Admiral::NS}/test foo`
              expect(config['test']).to eq('foo')
            end
          end
          context "and is valid JSON" do
            it "should return a parsed JSON object" do
              `etcdctl set #{Admiral::NS}/test '{"val": "foo"}'`
              expect(config['test']).to eq({"val" => "foo"})
            end
          end
        end

        context "and is a directory" do
          before(:each) do
            `etcdctl set #{Admiral::NS}/tests/1 foo`
            `etcdctl set #{Admiral::NS}/tests/2 bar`
          end

          it "should return that key's children" do
            result = config['tests'] 
            expect(result).to be_a(Array)
            expect(result[0].value).to eq('foo')
            expect(result[1].value).to eq('bar')
          end
        end
      end
    end

  end
end
