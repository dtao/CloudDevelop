class Language
  class << self
    def all
      initialize_all if @list.nil?
      @list.sort_by(&:name)
    end

    def [](key)
      initialize_all if @hash.nil?
      @hash[key]
    end

    private
    def initialize_all
      @hash = {}
      @list = []

      # Compiled languages.
      %w{c clojure haskell groovy java lua}.each do |key|
        @list << (@hash[key] = Language.new(key, key.capitalize))
      end

      # Interpreted (etc.) languages.
      %w{perl python ruby scheme smalltalk}.each do |key|
        @list << (@hash[key] = Language.new(key, key.capitalize, "Run"))
      end

      # Special cases.
      @list << (@hash["cpp"]          = Language.new("cpp", "C++"))
      @list << (@hash["cs"]           = Language.new("cs", "C#"))
      @list << (@hash["coffeescript"] = Language.new("coffeescript", "CoffeeScript", "Run"))
      @list << (@hash["javascript"]   = Language.new("javascript", "JavaScript", "Run"))
      @list << (@hash["php"]          = Language.new("php", "PHP", "Run"))
      @list << (@hash["vb"]           = Language.new("vb", "Visual Basic"))
    end
  end

  attr_reader :key
  attr_reader :name
  attr_reader :verb

  def initialize(key, name, verb=nil)
    @key  = key
    @name = name
    @verb = verb || "Compile"
  end
end
