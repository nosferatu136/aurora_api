require 'rails_helper'

describe PlaylistSerializer do
  it 'renders the correct json' do
    artist = Factory(:artist)
    song = Factory(:song, artist: artist)
    playlist = Factory(:playlist)
    playlist.playlist_songs.create(song_id: song.id)

    expected_json = {
      playlist: {
        guid: playlist.guid,
        name: playlist.name,
        user_id: playlist.user_id,
        songs: [{ guid: song.guid, name: song.name, duration: song.duration, artist_guid: song.artist_guid }]
      }
    }

    expect(described_class.new(playlist).as_json).to eq(expected_json)
  end
end
