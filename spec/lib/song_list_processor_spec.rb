require 'rails_helper'

class SongListProcessorTester < SongListProcessor
  def initialize(params, action)
    @type = :album
    super
  end
end

describe SongListProcessorTester do
  let(:album)  { Factory(:album) }
  let(:artist) { Factory(:artist) }
  let(:song_1) { Factory(:song, artist: artist) }
  let(:song_2) { Factory(:song, artist: artist) }
  let(:song_3) { Factory(:song, artist: artist) }
  let(:error_message) { 'some_message' }
  let(:activemodel_errors) { double('ActiveModel::Errors', full_messages: [error_message]) }

  context 'when adding songs' do
    describe '#process' do
      context 'when adding songs' do
        it 'only adds songs not present in the album' do
          [song_1, song_2].each do |song|
            album.album_songs.create(song_id: song.id)
          end
          params = {
            song_ids: [song_1, song_2, song_3].map(&:id).map(&:to_s),
            album_id: album.id
          }
          processor = described_class.new(params, :add)
          expect { processor.process }.to change { AlbumSong.count }.by(1)
          expect(album.reload.songs).to include song_3
        end
      end

      context 'when removing songs' do
        it 'only removes songs not present in the album' do
          [song_1, song_2, song_3].each do |song|
            album.album_songs.create(song_id: song.id)
          end
          params = {
            song_ids: [song_1, song_2].map(&:id).map(&:to_s),
            album_id: album.id
          }
          processor = described_class.new(params, :remove)
          expect { processor.process }.to change { AlbumSong.count }.by(-2)
          expect(album.reload.songs).to eq [song_3]
        end
      end
    end

    describe '#status' do
      context 'when album is not found' do
        it 'returns :not_found status' do
          params = {
            song_ids: [],
            album_id: 1
          }
          processor = described_class.new(params, :add).process
          expect(processor.status).to eq :not_found
        end
      end

      context 'when album is found' do
        let(:params)  { { song_ids: [song_2.id.to_s], album_id: album.id } }

        context 'when process is successful' do
          it 'returns :ok status' do
            processor = described_class.new(params, :add).process
            expect(processor.status).to eq :ok
          end
        end


        context 'when process is unsuccessful' do
          it 'returns :unprocessable_entity status' do
            allow(Album).to receive(:find_by_id) { album }
            allow(album).to receive(:reload) { album }
            allow(album).to receive(:errors) { activemodel_errors }
            processor = described_class.new(params, :add).process
            expect(processor.status).to eq :unprocessable_entity
          end
        end
      end
    end

    describe '#errors' do
      context 'when album is not found' do
        it 'returns an empty array' do
          params = {
            song_ids: [],
            album_id: 1
          }
          processor = described_class.new(params, :add).process
          expect(processor.errors).to eq []
        end
      end

      context 'when album is found' do
        let(:params)  { { song_ids: [song_2.id.to_s], album_id: album.id } }

        context 'when process is successful' do
          it 'returns an empty array' do
            processor = described_class.new(params, :add).process
            expect(processor.errors).to eq []
          end
        end


        context 'when process is unsuccessful' do
          it "returns the album's errors" do
            allow(Album).to receive(:find_by_id) { album }
            allow(album).to receive(:reload) { album }
            allow(album).to receive(:errors) { activemodel_errors }
            processor = described_class.new(params, :add).process
            expect(processor.errors).to eq album.reload.errors.full_messages
          end
        end
      end
    end
  end
end