class Evaluation < ActiveRecord::Base
  belongs_to :collection
  has_many :members, through: :collections
end

