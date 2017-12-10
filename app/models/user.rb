class User < ActiveRecord::Base
  cattr_reader :ROLES
  @@ROLES = ['admin', 'worker', 'not-admitted']

  devise :database_authenticatable, :registerable, :rememberable, :trackable
  has_many :process_types, dependent: :destroy
  has_many :tasks, class_name: 'Task', foreign_key: 'responsible_user_id'

  has_and_belongs_to_many :roles

  geocoded_by :ip
  after_validation :geocode

  def to_s
    return "@#{username}"
  end

  def self.from_omniauth(auth)
    uid = auth['uid']
    name = auth['name']
    provider = auth['provider']
    user =  where(uid: uid, provider: provider).first || create_from_omniauth(auth)
    user.update_attributes(token: auth['credentials']['token'], secret: auth['credentials']['secret'])

    return user
  end

  def role?(role)
    role = role.to_s.downcase
    self.role == role
  end

  def self.create_from_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
      user.username = auth["info"]["nickname"]
    end
  end
end
