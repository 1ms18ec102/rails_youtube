class Review < ApplicationRecord
    belongs_to :friend
    validates :rtext, presence: true
end