class User < ApplicationRecord
  has_many :projects, foreign_key: "caseworker"
  has_many :notes
end
