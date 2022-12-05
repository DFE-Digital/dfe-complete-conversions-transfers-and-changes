require "rails_helper"

RSpec.feature "Regional delivery officers can create new projects" do
  before { sign_in_with_user(user) }

  context "when the user is a regional delivery officer" do
    let(:user) { create(:user, :regional_delivery_officer) }

    it "shows a button that adds a new voluntary conversion" do
      visit projects_path

      expect(page)
        .to have_link I18n.t("conversion_project.voluntary.new.title"), href: conversion_voluntary_new_path
    end

    it "shows a button that adds a new involuntary conversion" do
      visit projects_path

      expect(page)
        .to have_link I18n.t("conversion_project.involuntary.new.title"), href: conversion_involuntary_new_path
    end
  end
end
