require 'rails_helper'

describe PlaylistSerializer do
  it 'renders the correct json' do
    artist = Factory(:artist)
    song = Factory(:song, artist: artist)
    playlist = Factory(:playlist)
    playlist.playlist_songs.create(song_id: song.id)

    expected_json = {
      playlist: {
        id: playlist.id,
        name: playlist.name,
        user_id: playlist.user_id,
        songs: [{ id: song.id, name: song.name, duration: song.duration, artist_id: song.artist_id }]
      }
    }

    expect(described_class.new(playlist).as_json).to eq(expected_json)
  end
end
