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
      @list = []

      @list << Language.new({
        :key  => "coffeescript",
        :mode => "text/x-coffeescript",
        :name => "CoffeeScript",
        :verb => "Run"
      })

      @list << Language.new({
        :key  => "javascript",
        :mode => "text/javascript",
        :name => "JavaScript",
        :verb => "Run"
      })

      @hash = {}
      @list.each do |lang|
        @hash[lang.key] = lang
      end
    end
  end

  attr_reader :key
  attr_reader :mode
  attr_reader :name
  attr_reader :verb

  def initialize(options={})
    @key  = options[:key]
    @mode = options[:mode] || @key
    @name = options[:name]
    @verb = options[:verb] || "Compile"
  end
end
