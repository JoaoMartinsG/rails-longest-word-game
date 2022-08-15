require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    letter_array = ('A'..'Z').to_a
    @letters = letter_array.sample(10)
    @joined_letters = @letters.join(',')
  end

  def score
    @word = params[:word]
    if !valid_word?(@word)
      @message = "Sorry but #{@word} doest not seem to be a valid English word..."
    elsif !valid_word_in_grid?(@word)
      @message = "Sorry but #{@word.upcase} can't be build out of #{params[:letters]}"
    else
      @message = "Congratulations! #{@word.upcase} is a valid English word!"
    end
  end

  private

  def valid_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    serialized_word = URI.open(url).read
    jsondata = JSON.parse(serialized_word)
    jsondata['found']
  end

  def valid_word_in_grid?(word)
    word.chars.all? { |letter| word.count(letter) == letter.count(letter) }
  end
end
