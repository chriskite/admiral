module Admiral
  class NotificationFactory

    def self.create(config)
      klass = Admiral::Notification.const_get(config.key.split('/').last.capitalize)
      klass.new
    end

  end
end
