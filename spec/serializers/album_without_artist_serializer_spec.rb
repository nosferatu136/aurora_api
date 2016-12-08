require 'rails_helper'

describe AlbumWithoutArtistSerializer do
  it 'renders the correct json' do
    artist = Factory(:artist)
    song = Factory(:song)
    album = Factory(:album, artist: artist)
    album.album_songs.create(song_id: song.id)

    expected_json = {
      album_without_artist: {
        guid: album.guid,
        name: album.name,
        art_id: album.art_id,
        artist_guid: album.artist.guid,
        released_at: album.released_at,
        songs: [{ guid: song.guid, name: song.name, duration: song.duration, artist_guid: song.artist_guid }]
      }
    }

    expect(described_class.new(album).as_json).to eq(expected_json)
  end
end
