class Interest < ActiveRecord::Base
  belongs_to :member
  belongs_to :genre
end
