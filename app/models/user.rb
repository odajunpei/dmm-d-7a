class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  attachment :profile_image
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  
  has_many :relationships, foreign_key: 'user_id'
  has_many :followings, through: :relationships, source: :follow
  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'follow_id',dependent: :destroy
  has_many :followers, through: :reverse_of_relationships, source: :user
  
   def following?(other_user)
    self.followings.include?(other_user)
   end

  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end 
  
  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end 
  
  def self.search(search,word)
    if search == "forward_match"
                     @user = User.where("name LIKE?","#{word}%")
    elsif search == "backward_match"
                     @user = User.where("name LIKE?","%#{word}")
    elsif search == "perfect_match"
                     @user = User.where("name LIKE?","#{word}")
    elsif search == "partial_match"
                     @user = User.where("name LIKE?","%#{word}%")
    else
                     @user = User.all
    end
  end
  
  validates :name, length: {minimum: 2,maximum: 20}, uniqueness: true
  validates :introduction, length: {maximum: 50}
end
