module Admiral
  class NotifierFactory

    def create(config)
      klass = Admiral::Notifier.const_get(config.key.split('/').last.capitalize)
      klass.new
    end

  end
end
