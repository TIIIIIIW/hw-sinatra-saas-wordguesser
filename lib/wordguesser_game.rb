class WordGuesserGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  # Get a word from remote "random word" service

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
    @guessed_letters = []
    @guessed_wrong = []
    @result = ''
  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start { |http|
      return http.post(uri, "").body
    }
  end

  def word ; @word ; end

  def result ; @result ; end

  def guesses ; @guesses ; end

  def wrong_guesses ; @wrong_guesses ; end

  def word=(new_word) ; @word = new_word ; end

  def guess(new_guess)
    raise ArgumentError.new("Got nill") if new_guess.nil?
    raise ArgumentError.new("Got empty word") if new_guess.empty?
    raise ArgumentError.new("Got not word") if !new_guess.match?(/[a-zA-Z]/)
    new_guess.downcase!
    if @word.include?(new_guess) && !@guessed_letters.include?(new_guess)
      @guesses = new_guess
      @guessed_letters << new_guess
    elsif !@word.include?(new_guess) && !@guessed_wrong.include?(new_guess)
      @wrong_guesses = new_guess
      @guessed_wrong << new_guess
    else 
      false
    end  
  end

  def word_with_guesses
    result = ""
    @word.each_char do |char|
      if @guessed_letters.include?(char)
        result << char
      else
        result << "-"
      end
    end
    @result = result
    result
  end

  def check_win_or_lose
    if word_with_guesses == @word
      :win
    elsif @guessed_wrong.length >= 7
      :lose
    else
      :play
    end
  end

end
