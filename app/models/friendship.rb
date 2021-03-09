class Friendship < ApplicationRecord
  ACCEPT = 1
  REJECT = -1
  PENDING = 0

  after_initialize :default_status

  validates :status, :user_id, :friend_id, presence: true
  validates :user_id, uniqueness: { scope: [:friend_id] }

  belongs_to :user
  belongs_to :friend, class_name: 'User'

  scope :all_of_status, ->(u, s) { where('(user_id=? OR friend_id=?) AND status=?', u, u, s) }
  scope :all_related_with_status, lambda { |u, f, s|
                                    where('((user_id=? AND friend_id=?) OR (user_id=? AND friend_id=?)) AND status=?',
                                          u, f, f, u, s)
                                  }
  scope :all_received_of_status, ->(u, s) { where('friend_id=? AND status=?', u, s) }

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
