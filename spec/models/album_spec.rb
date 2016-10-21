require 'rails_helper'

describe Album do
  let(:artist) { Factory(:artist) }
  let(:album_params) do
    {
      name: 'Master of Puppets',
      released_at: Date.today - 30.years,
      artist_id: artist.id,
      art_id: 2
    }
  end

  context 'when all attributes are present' do
    it 'is valid' do
      expect(described_class.new(album_params)).to be_valid
    end
  end

  context 'when name, duration or artist_id attribute is missing' do
    it 'is invalid' do
      album_params.delete(:art_id)
      album_params.dup.keys.each do |key|
        album_params.delete(key)
        expect(described_class.new(album_params)).to be_invalid
      end
    end
  end
end
