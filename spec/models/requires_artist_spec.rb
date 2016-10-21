require 'rails_helper'

class RequiresArtistTester
  include RequiresArtist

  attr_reader :artist_id

  def initialize(artist_id)
    @artist_id = artist_id
  end

  def valid?
    artist_presence
  end

  def errors
    @errors ||= ActiveModel::Errors.new(self)
  end
end

describe RequiresArtistTester do
  let(:song_params) { { name: 'La Bamba', duration: 14600, artist_id: 1 } }

  context 'when specified artist does not exist' do
    it 'adds the correct error' do
      tester = described_class.new(1)
      expect { tester.valid? }.to change { tester.errors.full_messages.size }.by(1)
      expect(tester.errors.full_messages).to include 'Specified artist does not exist'
    end
  end

  context 'when specified artist exists' do
    it 'adds no errors' do
      artist = Factory(:artist)
      tester = described_class.new(artist.id)
      expect { tester.valid? }.not_to change { tester.errors.full_messages.size }
    end
  end
end
