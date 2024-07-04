require "rails_helper"

RSpec.describe CookiesForm, type: :model do
  it "returns the responses using the form" do
    cookie_form = CookiesForm.new
    expect(cookie_form.responses.first.id).to be true
    expect(cookie_form.responses.last.id).to be false
  end

  it "has accept_optional_cookies attribute" do
    cookie_form = CookiesForm.new(accept_optional_cookies: false)
    cookie_form.accept_optional_cookies = true
    expect(cookie_form.accept_optional_cookies).to eq(true)
  end
end
