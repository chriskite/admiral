require 'spec_helper'

module Admiral
  describe Unit do

    describe "#new" do
      it "converts a unit hash array into a hash and gets the unit from etcd" do
        unit_hash_array = [134,169,247,235,91,47,165,204,64,160,168,28,213,171,227,47,30,229,164,231]
        hash = "86a9f7eb5b2fa5cc40a0a81cd5abe32f1ee5a4e7"
        data = '{"Raw":""}'
        etcd_mock = double()
        allow(Admiral).to receive(:etcd).and_return(etcd_mock)
        expect(etcd_mock).to receive(:get).with("/_coreos.com/fleet/unit/#{hash}").and_return(data)

        unit = Unit.new(unit_hash_array)
      end
    end

    describe "#instance" do
      context "when MachineMetadata specifies an instnace" do
        it "returns the AWS instance" do
          unit_hash_array = [134,169,247,235,91,47,165,204,64,160,168,28,213,171,227,47,30,229,164,231]
          hash = "86a9f7eb5b2fa5cc40a0a81cd5abe32f1ee5a4e7"
          data = <<END
  {"Raw":"[Service]\\nExecStartPre=-/usr/bin/docker kill %n\\nExecStartPre=-/usr/bin/docker rm %n\\nExecStart=/usr/bin/docker run --rm -name %n redis\\nExecStop=/usr/bin/docker stop -t 3 %n\\n\\n[X-Fleet]\\nMachineMetadata=instance=r3.2xlarge\\n"}
END
          etcd_mock = double()
          allow(Admiral).to receive(:etcd).and_return(etcd_mock)
          expect(etcd_mock).to receive(:get).with("/_coreos.com/fleet/unit/#{hash}").and_return(data)

          unit = Unit.new(unit_hash_array)
          expect(unit.instance).to eq("r3.2xlarge")
        end
      end

      context "when no metadata specifies and instance" do
        it "returns nil" do
          unit_hash_array = [134,169,247,235,91,47,165,204,64,160,168,28,213,171,227,47,30,229,164,231]
          hash = "86a9f7eb5b2fa5cc40a0a81cd5abe32f1ee5a4e7"
          data = '{"Raw":""}'
          etcd_mock = double()
          allow(Admiral).to receive(:etcd).and_return(etcd_mock)
          expect(etcd_mock).to receive(:get).with("/_coreos.com/fleet/unit/#{hash}").and_return(data)

          unit = Unit.new(unit_hash_array)
          expect(unit.instance).to be_nil
        end
      end
    end

  end
end
