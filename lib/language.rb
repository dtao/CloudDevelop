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
        :key            => "cpp",
        :file           => "clike",
        :mode           => "text/x-c++src",
        :name           => "C++",
        :verb           => "Compile",
        :snippets       => {
          :source       => Language::Snippets::CPlusPlus::SOURCE,
          :instructions => Language::Snippets::CPlusPlus::INSTRUCTIONS
        }
      })

      @list << Language.new({
        :key            => "cs",
        :file           => "clike",
        :mode           => "text/x-csharp",
        :name           => "C#",
        :verb           => "Compile",
        :snippets       => {
          :source       => Language::Snippets::CSharp::SOURCE,
          :instructions => Language::Snippets::CSharp::INSTRUCTIONS
        }
      })

      @list << Language.new({
        :key            => "coffeescript",
        :mode           => "text/x-coffeescript",
        :name           => "CoffeeScript",
        :verb           => "Run",
        :engine_type    => :jasmine,
        :snippets       => {
          :source       => Language::Snippets::CoffeeScript::SOURCE,
          :spec         => Language::Snippets::CoffeeScript::SPEC,
          :instructions => Language::Snippets::CoffeeScript::INSTRUCTIONS
        }
      })

      @list << Language.new({
        :key            => "java",
        :file           => "clike",
        :mode           => "text/x-java",
        :name           => "Java",
        :verb           => "Compile",
        :snippets => {
          :source       => Language::Snippets::Java::SOURCE,
          :instructions => Language::Snippets::Java::INSTRUCTIONS
        }
      })

      @list << Language.new({
        :key            => "javascript",
        :mode           => "text/javascript",
        :name           => "JavaScript",
        :verb           => "Run",
        :engine_type    => :jasmine,
        :snippets       => {
          :source       => Language::Snippets::JavaScript::SOURCE,
          :spec         => Language::Snippets::JavaScript::SPEC,
          :instructions => Language::Snippets::JavaScript::INSTRUCTIONS
        }
      })

      @list << Language.new({
        :key            => "python",
        :mode           => "text/x-python",
        :name           => "Python",
        :verb           => "Run",
        :snippets => {
          :source       => Language::Snippets::Python::SOURCE,
          :instructions => Language::Snippets::Python::INSTRUCTIONS
        }
      })

      @list << Language.new({
        :key            => "ruby",
        :mode           => "text/x-ruby",
        :name           => "Ruby",
        :verb           => "Run",
        :engine_type    => :rspec,
        :snippets => {
          :source       => Language::Snippets::Ruby::SOURCE,
          :spec         => Language::Snippets::Ruby::SPEC,
          :instructions => Language::Snippets::Ruby::INSTRUCTIONS
        }
      })

      @list << Language.new({
        :key            => "vb",
        :mode           => "text/x-vb",
        :name           => "VB.NET",
        :verb           => "Compile",
        :snippets => {
          :source       => Language::Snippets::VisualBasic::SOURCE,
          :instructions => Language::Snippets::VisualBasic::INSTRUCTIONS
        }
      })

      @hash = {}
      @list.each do |lang|
        @hash[lang.key] = lang
      end
    end
  end

  attr_reader :key
  attr_reader :file
  attr_reader :mode
  attr_reader :name
  attr_reader :verb
  attr_reader :engine_type
  attr_reader :snippets

  def initialize(options={})
    @key         = options[:key]
    @file        = options[:file] || @key
    @mode        = options[:mode] || @key
    @name        = options[:name]
    @verb        = options[:verb] || "Compile"
    @engine_type = options[:engine_type] || :ideone
    @snippets    = options[:snippets] || {}
  end

  def engine
    Engine.for_language(self)
  end
end
