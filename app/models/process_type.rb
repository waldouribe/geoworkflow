class ProcessType < ActiveRecord::Base
  belongs_to :user
  validates :name, :hashtag, presence: true
  has_many :my_processes, dependent: :destroy

  def to_s
    return name
  end
end
