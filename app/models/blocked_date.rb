class BlockedDate < ApplicationRecord
  belongs_to :blockable, polymorphic: true
end
