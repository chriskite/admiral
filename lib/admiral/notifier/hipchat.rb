module Admiral
  module Notifier
    class Hipchat

      def initialize
        api_token = Admiral.config['notification/hipchat/token']
        puts "api_token = #{api_token}"
        @rooms = Admiral.config['notification/hipchat/rooms']
        @hipchat = ::HipChat::Client.new(api_token, :api_version => 'v2')
      end

      def notify(name, state)
        msg = "[Fleet] #{name} entered failed state"

        @rooms.each do |room_config|
          room_opts = JSON.parse(room_config.value).to_options
          room_name = room_opts.delete(:name)
          @hipchat[room_name].send('Admiral', msg, room_opts)
        end
      end

    end
  end
end
