# == Schema Information
#
# Table name: players
#
#  id              :integer          not null, primary key
#  email           :string
#  image           :string
#  name            :string
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  current_game_id :integer
#

class Player < ApplicationRecord
  validates :email, :uniqueness => { :case_sensitive => false }
  validates :email, :presence => true
  has_secure_password
end
