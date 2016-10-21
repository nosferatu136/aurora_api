require 'rails_helper'

describe Song do
  let(:artist) { Factory(:artist) }
  let(:song_params) { { name: 'La Bamba', duration: 14600, artist_id: artist.id } }

  context 'when all attributes are present' do
    it 'is valid' do
      expect(described_class.new(song_params)).to be_valid
    end
  end

  context 'when name, duration or artist_id attribute is missing' do
    it 'is invalid' do
      song_params.dup.keys.each do |key|
        song_params.delete(key)
        expect(described_class.new(song_params)).to be_invalid
      end
    end
  end
end
