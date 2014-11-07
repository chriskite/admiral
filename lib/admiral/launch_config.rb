module Admiral
  class LaunchConfig
    NS = "aws"
    AMI_MAP = {
      "eu-central-1" => "ami-eec6f0f3",
      "ap-northeast-1" => "ami-838eb882",
      "sa-east-1" => "ami-75922668",
      "ap-southeast-2" => "ami-1dabc627",
      "ap-southeast-1" => "ami-7878592a",
      "us-east-1" => "ami-d878c3b0",
      "us-west-2" => "ami-f52c63c5",
      "us-west-1" => "ami-856772c0",
      "eu-west-1" => "ami-58e14e2f"
    }
    
    def ami
      AMI_MAP[region]
    end

    def security_group
      config 'security-group'
    end

    def tags
      {'Roles' => 'coreos'}
    end

    def storage
      100 # GB
    end

    def region
      config 'region'
    end

    def az
      config 'az'
    end

    def vpc
      config 'vpc'
    end

    def subnet
      config 'subnet'
    end

    def discovery_url
      config 'discovery-url'
    end

    def reboot_strategy
      config 'reboot-strategy' rescue 'off'
    end

    def user_data(instance)
      <<END
#cloud-config
coreos:
  etcd:
    discovery: #{discovery_url}
    addr: $private_ipv4:4001
    peer-addr: $private_ipv4:7001
  fleet:
    metadata: az=#{az},instance=#{instance}
  update:
    reboot-strategy: #{reboot_strategy}
  units:
    - name: etcd.service
      command: start
    - name: fleet.service
      command: start
END
    end

    private

    def config(key)
      Admiral.config["#{NS}/#{key}"] 
    end

  end
end
