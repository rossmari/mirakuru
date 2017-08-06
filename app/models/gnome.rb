class Gnome < ActiveRecord::Base

  class << self
    def read(name)
      Gnome.find_by(name: name).try(:value)
    end
  end

end