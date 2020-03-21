# == Schema Information
#
# Table name: games
#
#  id         :integer          not null, primary key
#  passcode   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  creator_id :integer
#

class Game < ApplicationRecord
end
