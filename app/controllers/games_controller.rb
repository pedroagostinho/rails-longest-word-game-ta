require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    size = 10
    @letters = []
    @start_time = Time.now
    # @letters = Array.new(10) { [*'A'..'Z'].sample }

    size.times do
      @letters << ('A'..'Z').to_a.sample
    end
  end

  def score
    @word = params[:word]
    @letters = params[:letters].gsub(/[^A-Z]/, '').split('')
    @start_time = Time.parse(params[:start_time])
    @end_time = Time.now
    @time = (@end_time - @start_time).round

    response = open("https://wagon-dictionary.herokuapp.com/#{@word}")
    json = JSON.parse(response.read)

    if json['found'] == false
      @score = 0
      @message = "Sorry but <strong>#{@word.upcase}</strong> does not seem to be a valid English word... You scored #{@score} points"
    elsif @word.upcase.chars.all? { |letter| @word.upcase.count(letter) <= @letters.count(letter) }
      @score = [(100 - @time.to_i), 1].max + @word.size
      @message = "<strong>Congratulations!</strong> #{@word.upcase} is a valid English word! You scored #{@score} points, and have taken #{@time} seconds"
    else
      @score = 0
      @message = "Sorry but <strong>#{@word.upcase}</strong> can't be built out of '#{@letters.join(' ')}'. You scored #{@score} points"
    end
    { time: @time, message: @message, score: @score }
  end
end
