AuroraApi::Application.routes.draw do
  resources :artists, param: :guid, only: [:index, :show, :create, :update, :destroy]
  resources :songs, param: :guid, only: [:index, :show, :create, :update, :destroy]
  resources :albums, param: :guid, only: [:index, :show, :create, :update, :destroy]
  resources :playlists, param: :guid, only: [:index, :show, :create, :update, :destroy]
  match 'albums/:album_guid/songs/add' => 'albums#add_songs', :via => :post
  match 'albums/:album_guid/songs/remove' => 'albums#remove_songs', :via => :delete
  match 'playlists/:playlist_guid/songs/add' => 'playlists#add_songs', :via => :post
  match 'playlists/:playlist_guid/songs/remove' => 'playlists#remove_songs', :via => :delete
end
