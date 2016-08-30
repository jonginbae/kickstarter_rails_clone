# == Schema Information
#
# Table name: projects
#
#  id            :integer          not null, primary key
#  name          :string
#  description   :text
#  target_amount :decimal(, )
#  user_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Project < ActiveRecord::Base
  # Validations
  validates :name, presence: true
  validates :description, length: {minimum: 10}
  validates :target_amount, numericality: {greater_than: 0}

  # Associations
  belongs_to :user
  has_many :pledges
  has_and_belongs_to_many :categories

  # Logic
  def pledge_sum
    self.pledges.sum(:amount)
  end

  def target_shortfall
    self.target_amount - pledge_sum
  end

  def pledges?
    pledge_sum > 0
  end

  def shortfall?
    target_shortfall > 0
  end

  def target_percent
    (pledge_sum / self.target_amount) * 100
  end

  def target_surplus
    pledge_sum - self.target_amount
  end

end