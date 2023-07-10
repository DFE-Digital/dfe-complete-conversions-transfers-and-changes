class UserAccountMailer < ApplicationMailer
  def new_account_added(user)
    template_mail(
      "d55de8f1-ce5a-4498-8229-baac7c0ee45f",
      to: user.email,
      personalisation: {
        first_name: user.first_name
      }
    )
  end
end
