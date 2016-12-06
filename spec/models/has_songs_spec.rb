require 'rails_helper'

describe HasSongs do
  let(:album)  { Factory(:album) }
  let(:artist) { Factory(:artist) }
  let(:song_1) { Factory(:song, artist: artist) }
  let(:song_2) { Factory(:song, artist: artist) }
  let(:song_3) { Factory(:song, artist: artist) }

  before do
    album.extend(HasSongs)
  end

  describe '#add_songs' do
    it 'only adds songs not present in the album' do
      [song_1, song_2].each do |song|
        album.album_songs.create(song_id: song.id)
      end
      song_ids = [song_1, song_2, song_3].map(&:id)

      expect { album.add_songs(song_ids) }.to change { AlbumSong.count }.by(1)
      expect(album.songs.size).to eq 3
      expect(album.songs).to include song_3
    end
  end

  describe '#remove_songs' do
    before do
      [song_1, song_2, song_3].each do |song|
        album.album_songs.create(song_id: song.id)
      end
    end

    it 'only removes songs present in the album' do
      song_ids = [song_1, song_2].map(&:id)

      expect { album.remove_songs(song_ids) }.to change { AlbumSong.count }.by(-2)
      expect(album.songs.size).to eq 1
      expect(album.songs).to eq [song_3]
    end

    context 'when no ids are passed' do
      it 'removes all album songs' do
        album.remove_songs(nil)
        expect(album.songs).to be_empty
      end
    end
  end
end
