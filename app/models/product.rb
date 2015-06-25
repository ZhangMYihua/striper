class Product < ActiveRecord::Base
  belongs_to :user
  has_attached_file :file

  belongs_to :user
end
