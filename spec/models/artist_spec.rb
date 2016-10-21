require 'rails_helper'

describe Artist do
  let(:artist_params) { { name: 'Wayne Static', bio: 'A very short bio', alias: 'Crazy X' } }

  context 'when all params are present' do
    it 'is valid' do
      expect(described_class.new(artist_params)).to be_valid
    end
  end

  context 'when name attribute is missing' do
    it 'is invalid' do
      artist_params.delete(:name)
      expect(described_class.new(artist_params)).to be_invalid
    end
  end

  context 'when an artist with the same name already exists' do
    it 'is invalid' do
      Factory(:artist, name: artist_params[:name])
      expect(described_class.new(artist_params)).to be_invalid
    end
  end
end
