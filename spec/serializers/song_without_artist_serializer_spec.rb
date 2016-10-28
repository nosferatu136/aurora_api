require 'rails_helper'

describe SongWithoutArtistSerializer do
  it 'renders the correct json' do
    artist = Factory(:artist)
    song = Factory(:song, artist: artist)

    expected_json = {
      song_without_artist: {
        id: song.id,
        name: song.name,
        duration: song.duration,
        artist_id: artist.id
      }
    }

    expect(described_class.new(song).as_json).to eq(expected_json)
  end
end
