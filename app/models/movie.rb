class Movie < ActiveRecord::Base

  def self.all_ratings
    %w[G PG PG-13 R].to_enum
  end

end
