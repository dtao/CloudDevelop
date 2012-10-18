class Engine
  class << self
    def register(type, engine)
      @engines ||= {}
      @engines[type] = engine
    end

    def for_language(language)
      @engines && @engines[language.engine_type]
    end
  end
end
