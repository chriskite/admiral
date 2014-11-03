module Admiral
  class NotifierFactory

    def self.create(config)
      klass = Admiral::Notifier.const_get(config.key.split('/').last.capitalize)
      klass.new
    end

  end
end
