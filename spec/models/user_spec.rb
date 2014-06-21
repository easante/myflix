require 'spec_helper'

describe User do
  it { should have_many(:queue_items) }
  it { should have_many(:reviews) }
  it { should have_many(:friendships) }
  it { should have_many(:friends).through(:friendships) }
  it { should have_many(:inverse_friendships).class_name('Friendship').with_foreign_key('friend_id') }
  it { should have_many(:inverse_friends).through(:inverse_friendships).source(:user) }
  it { should have_many(:invitations) }

  it "requires a fullname" do
    user = User.new(full_name: "")
    expect(user).not_to be_valid
    expect(user.errors[:full_name].any?).to be_true
  end

  it "requires an email" do
    user = User.new(email: "")
    expect(user).not_to be_valid
    expect(user.errors[:email].any?).to be_true
  end

  describe "#follows_or_same" do
    it "determines if a user follows another" do
      john = Fabricate(:user)
      bob = Fabricate(:user)
      user = Fabricate(:user)

      follower1 = Fabricate(:friendship, user_id: user.id, friend_id: bob.id)
      follower2 = Fabricate(:friendship, user_id: user.id, friend_id: john.id)
      expect(user.follows_or_same?(bob)).to be_true
    end

    it "cannot follow himself" do
      john = Fabricate(:user)

      follower = Fabricate(:friendship, user_id: john.id, friend_id: john.id)
      expect(john.follows_or_same?(john)).to be_true
    end

    it "generates a random token when a user is created" do
      john = Fabricate(:user)
      expect(john.token).to be_present
    end
  end
end
