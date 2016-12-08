require 'rails_helper'

describe ArtistWithoutAlbumsSerializer do
  it 'renders the correct json' do
    artist = Factory(:artist)
    song = Factory(:song)
    album = Factory(:album, artist: artist)
    album.album_songs.create(song_id: song.id)

    expected_json = {
      artist_without_albums: {
        guid: artist.guid,
        name: artist.name,
        bio: artist.bio,
        alias: artist.alias
      }
    }

    expect(described_class.new(artist).as_json).to eq(expected_json)
  end
end
