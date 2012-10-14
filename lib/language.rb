class Language
  class << self
    def all
      @all ||= initialize_all
    end

    private
    def initialize_all
      all = %w{c clojure haskell groovy java lua perl python ruby scheme smalltalk}.map do |key|
        Language.new(key, key.capitalize)
      end

      # Special cases.
      all << Language.new('cpp', 'C++')
      all << Language.new('cs', 'C#')
      all << Language.new('javascript', 'JavaScript')
      all << Language.new('php', 'PHP')
      all << Language.new('vb', 'Visual Basic')

      all.sort_by(&:name)
    end
  end

  attr_reader :key
  attr_reader :name

  def initialize(key, name)
    @key = key
    @name = name
  end
end
