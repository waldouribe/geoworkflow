class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable

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

  def self.create_from_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
      user.username = auth["info"]["nickname"]
    end
  end
end
