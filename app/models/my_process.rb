class MyProcess < ActiveRecord::Base
  belongs_to :process_type
  belongs_to :user

  geocoded_by :address
  after_validation :geocode, if: :address_changed?
  
  def to_s
    return "[#{id}]: #{process_type.to_s} - #{user.to_s} - #{address} - #{starts_at.strftime('%d/%m/%Y %H:%M')}"
  end
end
