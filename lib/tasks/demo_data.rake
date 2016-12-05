namespace :demo_data do
  desc "Creates a small data set to dev environment."
  task :create => :environment do
    artist = Artist.create(name: 'Pantera', bio: 'Cool band from Texas', alias: 'None')
    # haha this album brings back memories!
    album = Album.create(name: 'Vulgar display of power', released_at: Date.new(1992, 2, 25), artist_id: artist.id)
    ['Mouth for War', 'A New Level', 'Walk', 'Fucking Holstile'].each do |title|
      Song.create(name: title, duration: 4.minutes, artist_id: artist.id)
    end
    Song.where(artist_id: artist.id).each do |song|
      album.album_songs.create(song_id: song.id)
    end
    playlist = Playlist.create(name: 'Cool list', user_id: 1)
    Song.limit(2).each do |song|
      playlist.playlist_songs.create(song_id: song.id)
    end
  end
end
