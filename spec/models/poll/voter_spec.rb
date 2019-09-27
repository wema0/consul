require "rails_helper"

describe Poll::Voter do
  describe "validations" do
    let(:poll) { create(:poll) }
    let(:booth) { create(:poll_booth) }
    let(:booth_assignment) { create(:poll_booth_assignment, poll: poll, booth: booth) }
    let(:voter) { create(:poll_voter) }
    let(:user) { create(:user, :level_two) }

    it "is valid" do
      expect(voter).to be_valid
    end

    it "is not valid without a user" do
      voter.user = nil
      expect(voter).not_to be_valid
    end

    it "is not valid without a poll" do
      voter.poll = nil
      expect(voter).not_to be_valid
    end

    it "is valid if has not voted" do
      voter = build(:poll_voter, :valid_document)

      expect(voter).to be_valid
    end

    it "is not valid if the user has already voted in the same poll or booth_assignment" do
      voter1 = create(:poll_voter, user: user, poll: poll)
      voter2 = build(:poll_voter, user: user, poll: poll)

      expect(voter2).not_to be_valid
      expect(voter2.errors.messages[:document_number]).to eq(["User has already voted"])
    end

    it "is not valid if the user has already voted in the same poll/booth" do
      voter1 = create(:poll_voter, user: user, poll: poll, booth_assignment: booth_assignment)
      voter2 = build(:poll_voter, user: user, poll: poll, booth_assignment: booth_assignment)

      expect(voter2).not_to be_valid
      expect(voter2.errors.messages[:document_number]).to eq(["User has already voted"])
    end

    it "is not valid if the user has already voted in different booth in the same poll" do
      booth_assignment1 = create(:poll_booth_assignment, poll: poll)
      booth_assignment2 = create(:poll_booth_assignment, poll: poll)

      voter1 = create(:poll_voter, user: user, poll: poll, booth_assignment: booth_assignment1)
      voter2 = build(:poll_voter, user: user, poll: poll, booth_assignment: booth_assignment2)

      expect(voter2).not_to be_valid
      expect(voter2.errors.messages[:document_number]).to eq(["User has already voted"])
    end

    it "is valid if the user has already voted in the same booth in different poll" do
      booth_assignment1 = create(:poll_booth_assignment, booth: booth)
      booth_assignment2 = create(:poll_booth_assignment, booth: booth, poll: poll)

      voter1 = create(:poll_voter, user: user, booth_assignment: booth_assignment1)
      voter2 = build(:poll_voter, user: user, booth_assignment: booth_assignment2)

      expect(voter2).to be_valid
    end

    it "is not valid if the user has voted via web" do
      answer = create(:poll_answer)
      create(:poll_voter, :from_web, user: answer.author, poll: answer.poll)

      voter = build(:poll_voter, poll: answer.question.poll, user: answer.author)
      expect(voter).not_to be_valid
      expect(voter.errors.messages[:document_number]).to eq(["User has already voted"])
    end

    context "origin" do

      it "is not valid without an origin" do
        voter.origin = nil
        expect(voter).not_to be_valid
      end

      it "is not valid without a valid origin" do
        voter.origin = "invalid_origin"
        expect(voter).not_to be_valid
      end

      it "is valid with a booth origin" do
        voter.origin = "booth"
        voter.officer_assignment = create(:poll_officer_assignment)
        expect(voter).to be_valid
      end

      it "is valid with a web origin" do
        voter.origin = "web"
        expect(voter).to be_valid
      end
    end

    context "assignments" do
      it "is not valid without a booth_assignment_id when origin is booth" do
        voter.origin = "booth"
        voter.booth_assignment_id = nil
        expect(voter).not_to be_valid
      end

      it "is not valid without an officer_assignment_id when origin is booth" do
        voter.origin = "booth"
        voter.officer_assignment_id = nil
        expect(voter).not_to be_valid
      end

      it "is valid without assignments when origin is web" do
        voter.origin = "web"
        voter.booth_assignment_id = nil
        voter.officer_assignment_id = nil
        expect(voter).to be_valid
      end
    end

  end

  describe "scopes" do

    describe "#web" do
      it "returns voters with a web origin" do
        voter1 = create(:poll_voter, :from_web)
        voter2 = create(:poll_voter, :from_web)
        voter3 = create(:poll_voter, :from_booth)

        web_voters = Poll::Voter.web

        expect(web_voters).to match_array [voter1, voter2]
      end
    end

    describe "#booth" do
      it "returns voters with a booth origin" do
        voter1 = create(:poll_voter, :from_booth)
        voter2 = create(:poll_voter, :from_booth)
        voter3 = create(:poll_voter, :from_web)

        booth_voters = Poll::Voter.booth

        expect(booth_voters).to match_array [voter1, voter2]
      end
    end

  end

  describe "save" do

    it "sets demographic info" do
      geozone = create(:geozone)
      user = create(:user,
                    geozone: geozone,
                    date_of_birth: 30.years.ago,
                    gender: "female")

      voter = build(:poll_voter, user: user)
      voter.save

      expect(voter.geozone).to eq(geozone)
      expect(voter.age).to eq(30)
      expect(voter.gender).to eq("female")
    end

    it "sets user info" do
      user = create(:user, document_number: "1234A", document_type: "1")
      voter = build(:poll_voter, user: user, token: "1234abcd")
      voter.save

      expect(voter.document_number).to eq("1234A")
      expect(voter.document_type).to eq("1")
      expect(voter.token).to eq("1234abcd")
    end
  end
end
