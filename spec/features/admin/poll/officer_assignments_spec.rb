require "rails_helper"

describe "Officer Assignments" do

  before do
    admin = create(:administrator)
    login_as(admin.user)
  end

  scenario "Index" do
    poll = create(:poll)

    create(:poll_officer, polls: [poll])
    create(:poll_officer, polls: [poll])
    create(:poll_officer)

    visit admin_poll_path(poll)

    click_link "Officers (2)"

    within("#officer_assignments") do
      expect(page).to have_content officer1.name
      expect(page).to have_content officer2.name
      expect(page).not_to have_content officer3.name
    end
  end

  scenario "Search", :js do
    poll = create(:poll)

    user1 = create(:user, username: "John Snow")
    user2 = create(:user, username: "John Silver")
    user3 = create(:user, username: "John Edwards")

    officer1 = create(:poll_officer, user: user1, polls: [poll])
    officer2 = create(:poll_officer, user: user2, polls: [poll])
    officer3 = create(:poll_officer, user: user3)

    visit admin_poll_path(poll)

    click_link "Officers (2)"

    fill_in "search-officers", with: "John"
    click_button "Search"

    within("#search-officers-results") do
      expect(page).to have_content officer1.name
      expect(page).to have_content officer2.name
      expect(page).not_to have_content officer3.name
    end
  end

end
