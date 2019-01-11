require "test_helper"

feature "Landing Page" do
  scenario "display landing page" do
    visit root_path
    page.must_have_content "Your New EHR is just a few clicks away."
    page.wont_have_content "GoodBy all!"
    page.has_css?('#copyright')
  end
end
