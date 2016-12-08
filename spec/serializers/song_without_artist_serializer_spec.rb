require 'rails_helper'

describe SongWithoutArtistSerializer do
  it 'renders the correct json' do
    artist = Factory(:artist)
    song = Factory(:song, artist: artist)

    expected_json = {
      song_without_artist: {
        guid: song.guid,
        name: song.name,
        duration: song.duration,
        artist_guid: song.artist_guid
      }
    }

    expect(described_class.new(song).as_json).to eq(expected_json)
  end
end
