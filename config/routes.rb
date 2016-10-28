AuroraApi::Application.routes.draw do
  resources :artists, only: [:index, :create, :update, :destroy]
  resources :songs, only: [:index, :create, :update, :destroy]
  resources :albums, only: [:index, :create, :update, :destroy]
  resources :playlists, only: [:index, :create, :update, :destroy]
  match 'albums/:album_id/songs/add' => 'albums#add_songs', :via => :post
  match 'albums/:album_id/songs/remove' => 'albums#remove_songs', :via => :post
  match 'playlists/:playlist_id/songs/add' => 'playlists#add_songs', :via => :post
  match 'playlists/:playlist_id/songs/remove' => 'playlists#remove_songs', :via => :post
end
