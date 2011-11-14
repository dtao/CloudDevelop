class Language
  class << self
    def all
      initialize_all if @all.nil?
      @all
    end

    private
    def initialize_all
      @all = %w{c haskell java lua perl python ruby scheme smalltalk}.map { |key| Language.new(key, key.capitalize) }

      # Special cases.
      @all << Language.new('cpp', 'C++')
      @all << Language.new('cs', 'C#')
      @all << Language.new('javascript', 'JavaScript')
      @all << Language.new('php', 'PHP')
      @all << Language.new('vb', 'Visual Basic')

      @all.sort! { |x, y| x.key <=> y.key }
    end
  end

  attr_reader :key
  attr_reader :name

  def initialize(key, name)
    @key = key
    @name = name
  end
end