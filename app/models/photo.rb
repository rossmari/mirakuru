class Photo < ActiveRecord::Base
  mount_uploader :file, PhotoUploader

  belongs_to :cover, polymorphic: true
end
