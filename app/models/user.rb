class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :active_friendships, class_name: "Relationship",
                                foreign_key: "invited_by_id",
                                dependent: :destroy
  has_many :passive_friendships, class_name: "Relationship",
                                 foreign_key: "invited_id",
                                 dependent: :destroy
  has_many :requested_friends, through: :active_friendships, source: :invited
  has_many :offered_friends, through: :passive_friendships, source: :invited_by

  has_many :notifications, foreign_key: "recipient_id"
  accepts_nested_attributes_for :notifications


  # Invite another user
  def invite(other_user)
    requested_friends << other_user
    notify(other_user)
  end

  def notify(user)
    Notification.create(sender_id: self.id, recipient_id: user.id)
  end

  # Approve the passive friendship
  def approve(other_user)
    passive_friendships.find_by("invited_by_id = ?", other_user.id).update_attribute(:status, true)
  end

  # Returns true if the user was invited by the other user
  def invited_by?(other_user)
    friends = passive_friendships.where("invited_by_id = ?", other_user.id)
    friends.any? ? true : false
  end

    # Returns true if the user has invited the other user
  def invited?(other_user)
    friends = active_friendships.where("invited_id = ?", other_user.id)
    friends.any? ? true : false
  end

  # Returns true if the user has a relationship with another user
  def connected_with?(other_user)
    friends = []
    friends << passive_friendships.where("invited_by_id = ?", other_user.id)
    friends << active_friendships.where("invited_id = ?", other_user.id)
    friends.any? ? true : false
  end

end
