class Book < ActiveRecord::Base
  belongs_to :member

  def data=(data)
p data.content_type
    self.image = data.read
  end

  # TODO ファイル検証

end
