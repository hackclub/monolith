# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LeaderProfile, type: :model do
  subject { build(:leader_profile) }

  ## db columns ##

  # metadata
  it { should have_db_column :created_at }
  it { should have_db_column :updated_at }
  it { should have_db_column :deleted_at }

  # relations
  it { should have_db_column :user_id }
  it { should have_db_column :new_club_application_id }

  # leader
  it { should have_db_column :leader_name }
  it { should have_db_column :leader_email }
  it { should have_db_column :leader_birthday }
  it { should have_db_column :leader_year_in_school }
  it { should have_db_column :leader_gender }
  it { should have_db_column :leader_ethnicity }
  it { should have_db_column :leader_phone_number }
  it { should have_db_column :leader_address }
  it { should have_db_column :leader_latitude }
  it { should have_db_column :leader_longitude }
  it { should have_db_column :leader_parsed_address }
  it { should have_db_column :leader_parsed_city }
  it { should have_db_column :leader_parsed_state }
  it { should have_db_column :leader_parsed_state_code }
  it { should have_db_column :leader_parsed_postal_code }
  it { should have_db_column :leader_parsed_country }
  it { should have_db_column :leader_parsed_country_code }

  # presence
  it { should have_db_column :presence_personal_website }
  it { should have_db_column :presence_github_url }
  it { should have_db_column :presence_linkedin_url }
  it { should have_db_column :presence_facebook_url }
  it { should have_db_column :presence_twitter_url }

  # skills
  it { should have_db_column :skills_system_hacked }
  it { should have_db_column :skills_impressive_achievement }
  it { should have_db_column :skills_is_technical }

  # misc
  it { should have_db_column :completed_at }

  ## enums

  it { should define_enum_for :leader_year_in_school }
  it { should define_enum_for :leader_gender }
  it { should define_enum_for :leader_ethnicity }

  ## validations ##

  it { should validate_presence_of :user }
  it { should validate_presence_of :new_club_application }
  it { should validate_email_format_of :leader_email }

  it 'validates urls' do
    expect(subject.valid?).to eq(true)

    subject.presence_personal_website = 'bad'
    subject.presence_github_url = 'bad'
    subject.presence_linkedin_url = 'bad'
    subject.presence_facebook_url = 'bad'
    subject.presence_twitter_url = 'bad'

    expect(subject.valid?).to eq(false)

    expect(subject.errors).to include(
      :presence_personal_website,
      :presence_github_url,
      :presence_linkedin_url,
      :presence_facebook_url,
      :presence_twitter_url
    )
  end

  it_behaves_like 'Geocodeable'
  it_behaves_like 'Recoverable'

  ## relationships ##

  it { should belong_to :user }
  it { should belong_to :new_club_application }

  it 'should prefill email with applicant info' do
    # when email is not set, prefill
    profile = create(:leader_profile)
    expect(profile.leader_email).to eq(profile.user.email)

    # when email is set, do not overwrite it
    profile = create(:leader_profile, leader_email: 'foo@bar.com')
    expect(profile.leader_email).to eq('foo@bar.com')
  end

  describe 'completed_at autosetting / unsetting' do
    let(:unsaved_profile) { build(:completed_leader_profile) }
    let(:profile) { unsaved_profile.save && unsaved_profile }

    it 'should set completed_at when required fields are completed' do
      expect(unsaved_profile.completed_at).to be_nil
      unsaved_profile.save
      expect(unsaved_profile.completed_at).to_not be_nil
    end

    it 'should not update completed_at when fields are updated' do
      starting_completed_at = profile.completed_at

      # let a little time pass
      sleep 0.1

      # modify a required field
      profile.skills_is_technical = false
      profile.save

      # ensure completed_at didn't change
      expect(starting_completed_at).to eq(profile.completed_at)
    end

    it 'should unset completed_at when required fields are unset' do
      # make sure completed_at is set
      expect(profile.completed_at).to_not be_nil

      # unset required field
      profile.skills_system_hacked = nil
      profile.save

      # ensure completed_at was unset
      expect(profile.completed_at).to be_nil
    end
  end

  it 'should become immutable after application is submitted' do
    profile = create(:completed_leader_profile)
    profile.new_club_application.submit!

    profile.update_attributes(leader_name: 'Jane Doe')
    expect(profile.errors[:base]).to include(
      'cannot edit leader profile after submit'
    )
  end
end
