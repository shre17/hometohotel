class Review < ApplicationRecord
  belongs_to :reviewable, polymorphic: true
  belongs_to :user

  after_create :eval_overall_rating, :eval_reviewable_rating

  private
    def eval_overall_rating
      rating = (accuracy.to_i + amenities.to_i + checkin.to_i + communication.to_i + cleanliness.to_i + location.to_i + service.to_i + food_quality.to_i).to_i/8
      self.update(overall_rating: rating.round(0))
    end

    def eval_reviewable_rating
      resource = self.reviewable
      rating = self.reviewable.reviews.pluck(:overall_rating).sum/resource.reviews.count
      resource.update(rating: rating.round(1)) unless self.reviewable_type == "Host"
    end
end
