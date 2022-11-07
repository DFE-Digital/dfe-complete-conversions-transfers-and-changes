class NoteForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :body
  attribute :user_id
  attribute :project

  validates :body, presence: true, allow_blank: false

  def create
    Note.create!(
      body:,
      user_id:,
      project:
    )
  end
end
