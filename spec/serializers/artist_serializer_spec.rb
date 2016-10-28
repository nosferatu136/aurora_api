require 'rails_helper'

describe ArtistSerializer do
  it 'renders the correct json' do
    artist = Factory(:artist)
    song = Factory(:song)
    album = Factory(:album, artist: artist)
    album.album_songs.create(song_id: song.id)

    expected_json = {
      artist: {
        id: artist.id,
        name: artist.name,
        bio: artist.bio,
        alias: artist.alias,
        albums: [{
          id: album.id,
          name: album.name,
          art_id: album.art_id,
          artist_id: album.artist_id,
          released_at: album.released_at,
          songs: [{
            id: song.id,
            name: song.name,
            duration: song.duration,
            artist_id: song.artist_id
          }]
        }]
      }
    }

    expect(described_class.new(artist).as_json).to eq(expected_json)
  end
end
