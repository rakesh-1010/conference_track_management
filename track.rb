class Track
  attr_accessor :talks
  def initialize(talks)

    @talks = talks
  end

  def self.all
    ObjectSpace.each_object(self).to_a
  end

  def self.count
    all.count
  end

  def get_tracks(time_limit)
    talk_timings = self.untracked_talks.map{|talk| talk.time_limit}
    talk_timings.length.downto(1).flat_map do |i|
      talk_timings.combination(i).to_a # take all subarrays of length `i`
    end.select do |a|
      a.inject(:+) == time_limit
    end
  end

  def untracked_talks
    @talks.reject { |e| e.to_s.empty? || e.tracked?}
  end

  def tracked_talks
    @talks.reject { |e| e.to_s.empty? || !e.tracked?}
  end

  def flag_tracked_talks(time_limit)
    tracks = get_tracks(time_limit)
    self.untracked_talks.each do |talk|
      first_track = tracks.first
      unless first_track.empty?
        if first_track.include?talk.time_limit
          talk_index = first_track.index(talk.time_limit)
          first_track.delete_at(
            talk_index
          )
          order  = tracked_talks.count
          talk.tracked = true
          talk.order = order
        end
      end
    end
  end

end
