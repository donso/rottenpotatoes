class Movie < ActiveRecord::Base

  def self.ratings
    self.find(:all, :select => "rating", :group => "rating").map(&:rating)
  end
end
