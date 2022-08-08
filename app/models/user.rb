class User < ApplicationRecord
  has_many :projects, foreign_key: "delivery_officer"
  has_many :notes
end
