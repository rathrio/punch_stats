# frozen_string_literal: true

require_relative './punch_stats/version'
require 'json'
require 'sinatra/base'

module PunchStats
  PUNCH_PATH = ENV['PUNCH_PATH']

  if PUNCH_PATH.to_s.empty?
    puts <<~INFO
      Please provide an absolute path to your local punch installation in the
      PUNCH_PATH environment variable, e.g. in your .bash_profile:

           export PUNCH_PATH=/Users/spongebob/projects/punch
    INFO

    exit(1)
  end

  PUNCH_EXECUTABLE = File.join(PUNCH_PATH, 'punch.rb')
  require PUNCH_EXECUTABLE

  ROOT = File.join(File.dirname(__FILE__), '../')

  def self.root
    ROOT
  end

  def self.ui_dist
    File.join(ROOT, 'ui/dist')
  end

  # @return [Array<Month>]
  def self.months
    Dir["#{Punch.config.hours_folder}/*.txt"]
      .map { |f| Month.from_file(f) }
      .reject(&:empty?)
  end

  def self.json_months
    months.map do |month|
      hash = {}

      hash[:name] = month.name
      hash[:year] = month.year
      hash[:number] = month.number
      hash[:total] = month.total

      hash[:days] = month.days.map do |day|
        {
          date: day.to_time.to_date,
          total: day.total,
          blocks: day.blocks.map do |b|
            { start: b.start, end: b.finish, total: b.total }
          end
        }
      end

      hash
    end.to_json
  end

  class Server < Sinatra::Base
    set :public_folder, PunchStats.ui_dist

    get '/' do
      send_file File.join(settings.public_folder, 'index.html')
    end

    get '/months' do
      content_type :json
      PunchStats.json_months
    end
  end
end
