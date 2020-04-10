# == Schema Information
#
# Table name: players
#
#  id              :integer          not null, primary key
#  chip_count      :integer
#  email           :string
#  folded          :boolean
#  image           :string
#  name            :string
#  password_digest :string
#  seat            :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  current_game_id :integer
#

class Player < ApplicationRecord
  validates :email, :uniqueness => { :case_sensitive => false }
  validates :email, :presence => true
  has_secure_password

end
