class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  scope :all_except, ->(user) { where.not(id: user) }
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]

  has_many :active_friendships, class_name: "Relationship",
                                foreign_key: "invited_by_id",
                                dependent: :destroy
  has_many :passive_friendships, class_name: "Relationship",
                                 foreign_key: "invited_id",
                                 dependent: :destroy
  has_many :requested_friends, through: :active_friendships, source: :invited
  has_many :offered_friends, through: :passive_friendships, source: :invited_by

  has_many :notifications, foreign_key: "recipient_id"
  has_many :posts, foreign_key: "author_id"
  has_many :comments, foreign_key: "commenter_id", dependent: :destroy
  has_many :likes, foreign_key: "liker_id", dependent: :destroy

  #validates_presence_of


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

  # return an array of ids for posts authors
  def friends_posts_ids
    array_of_ids = [id]
    array_of_ids << passive_friendships.accepted.pluck(:invited_by_id)
    array_of_ids << active_friendships.accepted.pluck(:invited_id)
    array_of_ids.flatten
  end

  # return an array of ids for pending friendships
  def pending_friends_posts_ids
    array_of_ids = []
    array_of_ids << passive_friendships.pending.pluck(:invited_by_id)
    array_of_ids.flatten
  end

  # return an array of ids for pending friendships that need to be accepted by the other user
  def requested_friends_posts_ids
    array_of_ids = []
    array_of_ids << active_friendships.pending.pluck(:invited_id)
    array_of_ids.flatten
  end

  # Returns an array of users that you have asked
  def asked_friends
    friendships = active_friendships
    if friendships.any?
      users = []
      friendships.each do |f|
        users << f.invited
      end
      users
    else
      false
    end
  end

  def accepted_friends
    Relationship.where(["invited_id = ? OR invited_by_id = ?", id, id]).accepted
  end

  def pending_friends
    Relationship.where(["invited_id = ? OR invited_by_id = ?", id, id]).pending
  end
  # Returns true if the user has a relationship with another user
  def connected_with?(other_user)
    friends = []
    friends << passive_friendships.where("invited_by_id = ?", other_user.id)
    friends << active_friendships.where("invited_id = ?", other_user.id)
    friends.any? ? true : false
  end

  # Create a like for the given post_id
  def like!(post)
    likes.create!(post_id: post.id)
  end

  # Destroys a like matching the post_id and user_id
  def unlike!(post)
    like = likes.find_by_post_id(post.id)
    like.destroy!
  end

  # Returns true or false if a post is liked by the user
  def like?(post)
    likes.find_by_post_id(post.id) ? true : false
  end

  def self.from_omniauth(auth)
  where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
    user.email = auth.info.email
    user.password = Devise.friendly_token[0,20]
    user.name = auth.info.name   # assuming the user model has a name
    # user.image = auth.info.image # assuming the user model has an image
    # If you are using confirmable and the provider(s) you use validate emails,
    # uncomment the line below to skip the confirmation emails.
    # user.skip_confirmation!
  end
end


end
