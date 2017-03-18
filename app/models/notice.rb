class Notice < ApplicationRecord
  require 'uri'

  # belongs to a department
  belongs_to :department

  # every object must validate presence of title
  # and notice body fields before saving
  validates :title, presence: true
  validates :notice_body, presence: true

  # format of link must be correct before saving
  validates :optional_link, format: { with: URI::regexp,:message => "is not a valid url" }

  # sets default value for broadcast attribute to false
  default_value_for :broadcast, false



end
