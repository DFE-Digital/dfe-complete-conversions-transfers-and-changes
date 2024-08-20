class Api::Persons::MemberDetails
  attr_reader :email

  def initialize(args = {})
    @first_name = args["firstName"]
    @last_name = args["lastName"]
    @email = args["email"]
  end

  def name
    "#{@first_name} #{@last_name}"
  end

  # In the application context, all MPs have this address
  def address
    [
      "House of Commons",
      "London",
      "SW1A 0AA"
    ]
  end
end
