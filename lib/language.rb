class Language
  class << self
    def all
      initialize_all if @list.nil?
      @list.sort_by(&:name)
    end

    def each(&block)
      all.each(&block)
    end

    def [](key)
      initialize_all if @hash.nil?
      @hash[key]
    end

    private
    def initialize_all
      @list = []

      @list << Language.new({
        :key            => "coffeescript",
        :mode           => "text/x-coffeescript",
        :name           => "CoffeeScript",
        :verb           => "Run",
        :snippets       => {
          :source       => Language::Snippets::CoffeeScript::SOURCE,
          :spec         => Language::Snippets::CoffeeScript::SPEC,
          :instructions => Language::Snippets::CoffeeScript::INSTRUCTIONS
        }
      })

      @list << Language.new({
        :key            => "javascript",
        :mode           => "text/javascript",
        :name           => "JavaScript",
        :verb           => "Run",
        :snippets       => {
          :source       => Language::Snippets::JavaScript::SOURCE,
          :spec         => Language::Snippets::JavaScript::SPEC,
          :instructions => Language::Snippets::JavaScript::INSTRUCTIONS
        }
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
  attr_reader :snippets

  def initialize(options={})
    @key      = options[:key]
    @mode     = options[:mode] || @key
    @name     = options[:name]
    @verb     = options[:verb] || "Compile"
    @snippets = options[:snippets] || {}
  end
end
