require_relative './track.rb'
require_relative './talk.rb'
require 'byebug'
require 'time'

module TrackManagement

  def self.input_talks(file_path)
    File.open(file_path, "r") do |f|
      f.each_line do |line|
        TrackManagement.initialize_talk(line)
      end
    end
    talks = Talk.all
    track = Track.new(talks)
    morning_sessions_time_limit = 180
    evening_sessions_time_limit = 180
    track.flag_tracked_talks(morning_sessions_time_limit)
    track.flag_tracked_talks(evening_sessions_time_limit)
    TrackManagement.return_talk_schedule
  end

  def self.initialize_talk(line)
    time_limit = TrackManagement.get_time_limit(line)
    title = line
    Talk.new(title, time_limit) if time_limit != 0
  end

  def self.get_time_limit(line)
    line.match('\w*min\b').to_a[0].to_i
  end

  def self.return_talk_schedule
    start_time = Time.parse "9:00 AM"
    talks = Talk.all.sort_by(&:order)
    talks.each_with_index do |talk, index|
      puts "#{start_time.strftime("%I:%M %p")}
        #{talk.title}
        #{talk.time_limit}" if index == 0
      start_time += talk.time_limit
      puts "#{(start_time).strftime("%I:%M %p")}
       #{talk.title}
       #{talk.time_limit}
       #{talk.order}" if index != 0
    end
  end

end

TrackManagement.input_talks("./talks.txt")
