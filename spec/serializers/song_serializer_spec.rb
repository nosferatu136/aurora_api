require 'rails_helper'

describe SongSerializer do
  it 'renders the correct json' do
    artist = Factory(:artist)
    song = Factory(:song, artist: artist)
    album = Factory(:album, artist: artist)

    expected_json = {
      song: {
        id: song.id,
        name: song.name,
        duration: song.duration,
        artist: { id: artist.id, name: artist.name, bio: artist.bio, alias: artist.alias }
      }
    }

    expect(described_class.new(song).as_json).to eq(expected_json)
  end
end
