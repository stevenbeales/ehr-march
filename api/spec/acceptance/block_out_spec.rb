require 'api_documentation_helper'

RSpec.resource 'Block out' do
  header 'Content-Type', 'application/vnd.api+json'

  post '/block_outs' do
    before do
      User.destroy_all
      BlockOut.destroy_all
    end
    let(:user)      { create(:provider).user }
    let(:patient)   { create :patient }

    parameter :auth_token,     'Authentication Token',                      required: true
    parameter :patient_id,     'Patient id',           scope: :block_out,   required: true
    parameter :time_for,       'Time for',             scope: :block_out
    parameter :block_datetime, 'Datetime',             scope: :block_out
    parameter :duration,       'Duration',             scope: :block_out
    parameter :description,    'Description',          scope: :block_out
    parameter :note,           'Note',                 scope: :block_out
    parameter :recurring,      'Recurring',            scope: :block_out
    parameter :recur_every,    'Recurring every',      scope: :block_out
    parameter :range_day,      'Day range',            scope: :block_out

    let(:auth_token)      { user.auth_token }
    let(:patient_id)      { patient.id }
    let(:time_for)        { BlockOut.time_fors.sample }
    let(:block_datetime)  { Time.now }
    let(:duration)        { BlockOut.durations.sample }
    let(:description)     { Faker::Lorem.sentence }
    let(:note)            { Faker::Lorem.sentence }
    let(:recurring)       { [true, false].sample }
    let(:recur_every)     { Faker::Lorem.word }
    let(:range_day)       { BlockOut.range_days.sample }

    example_request 'Create block out' do
      expect(status).to        eq 200
      expect(response_body).to eq JSONAPI::Serializer.serialize(BlockOut.last).to_json
    end
  end
end