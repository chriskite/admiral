module Admiral
  class Unit

    #
    # Creates unit from the unit hash array from fleet/job/x.service/object
    #
    def initialize(unit_hash_array)
      # convert [169, 139, ...] to "86a9..."
      @hash = unit_hash_array.map { |n| n.to_s(16) }.join
      unit_data = JSON.parse(
        Admiral.etcd.get("/_coreos.com/fleet/unit/#{@hash}")
      )
      @raw = unit_data['Raw']
    end

    #
    # Return the AWS instance required in MachineMetadata
    # or nil if there is none
    #
    def instance
      line = @raw.split("\n").grep(/^MachineMetadata=.*instance.*$/).first
      return nil if line.nil?
      line.match(/instance=([.a-z0-9]*)/)[1]
    end

  end
end
