module LocalAuthorityHelper
  def address_markup(address)
    address.compact_blank.join("<br/>")
  end
end
