require 'rails_helper'

describe AlbumWithoutArtistSerializer do
  it 'renders the correct json' do
    artist = Factory(:artist)
    song = Factory(:song)
    album = Factory(:album, artist: artist)
    album.album_songs.create(song_id: song.id)

    expected_json = {
      album_without_artist: {
        id: album.id,
        name: album.name,
        art_id: album.art_id,
        artist_id: album.artist_id,
        released_at: album.released_at,
        songs: [{ id: song.id, name: song.name, duration: song.duration, artist_id: song.artist_id }]
      }
    }

    expect(described_class.new(album).as_json).to eq(expected_json)
  end
end
