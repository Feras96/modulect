require 'rails_helper'

RSpec.describe User, type: :model do

  let(:user) { build(:user) }

  describe "when created into the database" do
    before do
      user.save
    end
    it "has an activation token" do
      expect(user.activation_token).not_to be_blank
    end
    it "has an activation digest" do
      expect(user.activation_digest).not_to be_blank
    end
    it "has a matching token for the digest" do
        expect(user.authenticated?(:activation,
                                    user.activation_token
                                    )).to eq true
    end
  end

  describe "before save" do
    context "when email contains capital letters" do
      before do
        user.email.upcase!
        user.save
      end
      it "downcases email" do
        expect(user.email).to eq user.email.downcase
      end
    end
  end

  describe "#remember" do
    before do
      user.update_attribute(:remember_digest, nil)
      user.remember
    end

    it "generates and saves a unique remember_token for the user" do
      expect(user.remember_token).not_to be_blank
    end

    it "generates and saves a digest of the user's unique remember token" do
      expect(user.remember_digest).not_to be_blank
    end
  end

  describe "#forget" do
    before do
      user.remember
      expect(user.remember_token).not_to be_blank
    end

    it "forgets the user's remember token" do
      user.forget
      expect(user.remember_token).to be_blank
    end
  end

  describe "#authenticated?" do
    before do
      user.remember
    end

    context "when checking if a user is a remembered user" do
      context "and the user's remember_token is passed" do
        it "returns true" do
          expect(user.authenticated?(:remember,
                                      user.remember_token
                                      )).to eq true
        end
      end

      context "and an incorrect remember_token is passed" do
        it "returns false" do
          expect(user.authenticated?(:remember, "DEADBEEF")).to eq false
        end
      end
    end
  end

  describe "#valid?" do

    context "when all fields are valid" do
      it "evaluates to true" do
        expect(user.valid?).to eq true
      end
    end

    context "when first name is blank" do
      before do
        user.first_name = nil
      end
      it "evaluates to false" do
        expect(user.valid?).to eq false
      end
    end

    context "when last name is blank" do
      before do
        user.last_name = nil
      end
      it "evaluates to false" do
        expect(user.valid?).to eq false
      end
    end

    context "when first name is longer than 70 characters" do
      before do
        user.first_name = "a" * 71
      end
      it "evaluates to false" do
        expect(user.valid?).to eq false
      end
    end

    context "when last name is longer than 70 characters" do
      before do
        user.last_name = "a" * 71
      end
      it "evaluates to false" do
        expect(user.valid?).to eq false
      end
    end

    context "when email is blank" do
      before do
        user.email = nil
      end
      it "evaluates to false" do
        expect(user.valid?).to eq false
      end
    end

    context "when email is of wrong format" do
      let(:invalid_emails) { %w(foo foo@bar foo@.bar
                               foo@bar.123 foo@bar..baz
                               foo.bar@baz @foo.bar) }
      it "evaluates to false" do
        invalid_emails.each do |email|
          user.email = email
          expect(user.valid?).to eq false
        end
      end
    end

    context "when email is already taken" do
      before do
        create(:user, email: user.email)
      end
      it "evaluates to false" do
        expect(user.valid?).to eq false
      end
    end

    context "when email is longer than 255 characters" do
      before do
        user.email = "a" * 256
      end
      it "evaluates to false" do
        expect(user.valid?).to eq false
      end
    end

    context "when user_level is one digit long" do
      context "but not 1|2|3" do
        before do
          user.user_level = 4
        end
        it "evaluates to false" do
          expect(user.valid?).to eq false
        end
      end
    end

    context "when user_level is longer than one digit" do
      before do
        user.user_level = 11
      end
      it "evaluates to false" do
        expect(user.valid?).to eq false
      end
    end

    context "when year_of_study is one digit long" do
      before do
        user.year_of_study = 1
      end
      it "evaluates to true" do
        expect(user.valid?).to eq true
      end
    end

    context "when year_of_study is longer than one digit" do
      before do
        user.year_of_study = 10
      end
      it "evaluates to false" do
        expect(user.valid?).to eq false
      end
    end
  end

  describe "#save_module" do
    let(:valid_uni_module) { create(:uni_module) }

    context "when passed a valid uni_module" do
      before do
        user.save
        user.save_module(valid_uni_module)
      end

      it "registers the uni modules as having been saved" do
        expect(user.uni_modules.include?(valid_uni_module)).to eq true
      end
    end
  end

  describe "#unsave_module" do
    let(:valid_uni_module) { create(:uni_module) }

    context "when passed a valid uni_module" do
      before do
        user.save
        user.unsave_module(valid_uni_module)
      end

      it "registers the uni modules as having been saved" do
        expect(user.uni_modules.exclude?(valid_uni_module)).to eq true
      end
    end
  end

end
