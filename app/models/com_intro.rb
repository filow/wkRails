class ComIntro < ActiveRecord::Base
  belongs_to :post, required: true
end
