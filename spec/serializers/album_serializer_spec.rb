require 'rails_helper'

describe AlbumSerializer do
  it 'renders the correct json' do
    artist = Factory(:artist)
    song = Factory(:song)
    album = Factory(:album, artist: artist)
    album.album_songs.create(song_id: song.id)

    # ? what if we didn't want to expose numeric database IDs? how would you change the data model and serializers?
    expected_json = {
      album: {
        id: album.id,
        name: album.name,
        art_id: album.art_id,
        released_at: album.released_at,
        artist: { id: artist.id, name: artist.name, bio: artist.bio, alias: artist.alias },
        songs: [{ id: song.id, name: song.name, duration: song.duration, artist_id: song.artist_id }]
      }
    }

    expect(described_class.new(album).as_json).to eq(expected_json)
  end
end
