class Friendship < ApplicationRecord
  ACCEPT = 1
  REJECT = -1
  PENDING = 0

  after_initialize :default_status

  validates :status, :user_id, :friend_id, presence: true
  validates :user_id, uniqueness: { scope: [:friend_id] }

  belongs_to :user
  belongs_to :friend, class_name: 'User'

  scope :all_of, ->(u) { where('user_id=? OR friend_id=?', u, u) }
  scope :all_received, ->(u) { where('friend_id=?', u) }
  scope :all_related, ->(u, f) { where('(user_id=? AND friend_id=?) OR (user_id=? AND friend_id=?)', u, f, f, u) }
  scope :with_status, ->(s) { where('status=?', s) }

  def accept
    self.status = Friendship::ACCEPT
    save!
  end

  def accepted?
    status == Friendship::ACCEPT
  end

  def reject
    self.status = Friendship::REJECT
    save!
  end

  def rejected?
    status == Friendship::REJECT
  end

  private

  def default_status
    self.status ||= Friendship::PENDING
  end
end
