## Aurora Music API
- Ruby version:  2.2.4
- Rails version: 3.2.22

## Endpoint reference

###  Get all artists

* **Endpoint**
```
GET    /artists
```
* **Parameters**

* **Response**
```
Type: Json
Array of artists
Each artist contains their albums and songs in each album
Body
  [{
    id: 1,
    name: 'artist',
    bio: 'some bio',
    alias: 'alias',
    albums: [{
      id: 2,
      name: 'album',
      art_id: 3,
      artist_id: 1,
      released_at: Fri, 28 Oct 2016,
      songs: [{
        id: 4,
        name: 'song',
        duration: 3600,
        artist_id: 1
      }]
    }]
  }]
```

###  Get one artist

* **Endpoint**
```
GET    /artists/:id
```
* **Parameters**
```
@id:      [Integer] Required. Id of the artist to be retrieved
```
* **Response**
```
Type: Json
Keys:
  artist: The retrived artist with albums and their songs
  status: Http response code
Body
  {
    artist: {
      id: 1,
      name: 'artist',
      bio: 'some bio',
      alias: 'alias',
      albums: [{
        id: 2,
        name: 'album',
        art_id: 3,
        artist_id: 1,
        released_at: Fri, 28 Oct 2016,
        songs: [{
          id: 4,
          name: 'song',
          duration: 3600,
          artist_id: 1
        }]
      }]
    }
  }
  status: 200
```

###  Create an artist

* **Endpoint**
```
POST   /artists
```
* **Parameters**
```
@name:    [String]  Required. Name of the artist
@bio:     [Text]    Artist biography
@alias:   [String]  Alternate artist name
```
* **Response**
```
Type: Json
Keys:
  artist: The new artist
  errors: ActiveRecord errors present on artist creation, if any
  status: Http response code
Body:
  {
    artist:
    {
      id: 1,
      name: 'artist',
      bio: 'some bio',
      alias: 'alias',
      albums: []
    },
    errors: []
  }
  status: 200
```
###  Change artist details

* **Endpoint**
```
PUT    /artists/:id
```
* **Parameters**
```
@id:      [Integer] Required. Id of the artist to be modified
@name:    [String]  Name of the artist
@bio:     [Text]    Artist biography
@alias:   [String]  Alternate artist name
```
* **Response**
```
Type: Json
Keys:
  artist: The modified artist (with artist and songs)
  errors: ActiveRecord errors present on artist edition, if any
  status: Http response code
Body:
  {
    artist: {
      id: 1,
      name: 'artist',
      bio: 'some bio',
      alias: 'alias',
      albums: [{
        id: 2,
        name: 'album',
        art_id: 3,
        artist_id: 1,
        released_at: Fri, 28 Oct 2016,
        songs: [{
          id: 4,
          name: 'song',
          duration: 3600,
          artist_id: 1
        }]
      }]
    },
    errors: []
  }
  status: 200
```
###  Delete an artist

* **Endpoint**
```
DELETE /artists/:id
```
* **Parameters**
```
@id:  [Integer] Required. Id of the artist to be deleted
```
* **Response**
```
status: 200
```
###  Get all songs

* **Endpoint**
```
GET    /songs
```
* **Parameters**

* **Response**
```
Array of songs
Each song contains the artist associated to it
Body
  [{
    id: 1,
    name: 'song',
    duration: 3600,
    artist: { id: 2, name: 'artist', bio: 'some bio', alias: 'alias' }
  }]
```
###  Get one song

* **Endpoint**
```
GET    /songs/:id
```
* **Parameters**
```
@id:      [Integer] Required. Id of the song to be retrieved
```
* **Response**
```
Type: Json
Keys:
  song: The retrived song with its associated artist
  status: Http response code
Body
  {
    song:
    {
      id: 1,
      name: 'song',
      duration: 3600,
      artist: { id: 2, name: 'artist', bio: 'some bio', alias: 'alias' }
    }
  }
  status: 200
```
###  Create a song

* **Endpoint**
```
POST   /songs
```
* **Parameters**
```
@name:        [String]  Required. Name of the song
@duration:    [Integer] Required. Time the song lasts (in seconds)
@artist_id:   [Integer] Required. Id of the artist associated to the song
```
* **Response**
```
Type: Json
Keys:
  song:   The new song including basic info on its artist
  errors: ActiveRecord errors present on song creation, if any
  status: Http response code
Body:
  {
    song:
    {
      id: 1,
      name: 'song',
      duration: 3600,
      artist: { id: 2, name: 'artist', bio: 'some bio', alias: 'alias' }
    },
    errors: []
  }
  status: 200
```
###  Change song details

* **Endpoint**
```
PUT    /songs/:id
```
* **Parameters**
```
@id:          [Integer] Required. Id of the song to be modified
@name:        [String]  Name of the song
@duration:    [Integer] Time the song lasts (in seconds)
@artist_id:   [Integer] Id of the artist associated to the song
```
* **Response**
```
Type: Json
Keys:
  song:   The new song including basic info on its artist
  errors: ActiveRecord errors present on song edition, if any
  status: Http response code
Body
  {
    song:
    {
      id: 1,
      name: 'song',
      duration: 3600,
      artist: { id: 2, name: 'artist', bio: 'some bio', alias: 'alias' }
    },
    errors: []
  }
  status: 200
```
###  Delete a song

* **Endpoint**
```
DELETE /songs/:id
```
* **Parameters**
```
@id:  [Integer] Required. Id of the song to be deleted
```
* **Response**
```
status: 200
```
###  Get all albums

* **Endpoint**
```
GET    /albums
```
* **Parameters**

* **Response**
```
Type: Json
Array of albums
Each album contains the artist and songs associated to it
Body
[{
  id: 1,
  name: 'album',
  art_id: 2,
  released_at: Fri, 28 Oct 2016,
  artist: { id: 2, name: 'artist, bio: 'some bio', alias: 'alias' },
  songs: [{ id: 3, name: 'song', duration: 3600, artist_id: 2 }]
}]
```
###  Get one album

* **Endpoint**
```
GET    /albums/:id
```
* **Parameters**
```
@id:      [Integer] Required. Id of the album to be retrieved
```
* **Response**
```
Type: Json
Keys:
  album: The retrived album with its associated artist and songs
  status: Http response code
Body
  {
    album:
    {
        id: 1,
        name: 'album',
        art_id: 2,
        released_at: Fri, 28 Oct 2016,
        artist: { id: 2, name: 'artist, bio: 'some bio', alias: 'alias' },
        songs: [{ id: 3, name: 'song', duration: 3600, artist_id: 2 }]
    }
  }
  status: 200
```
###  Create an album

* **Endpoint**
```
POST   /albums
```
* **Parameters**
```
@name:        [String]  Required. Name of the album
@artist_id:   [Integer] Required. Id of the artist associated to the album
@released_at: [Date]    Required. Date the album was released
@art_id:      [Integer] Id of the cover's art (image) for this album
```
* **Response**
```
Type: Json
Keys:
  album:  The new album
  errors: ActiveRecord errors present on album creation, if any
  status: Http response code
Body:
  {
    album:
    {
        id: 1,
        name: 'album',
        art_id: 2,
        released_at: Fri, 28 Oct 2016,
        artist: {},
        songs: []
    },
    errors: []
  }
  status: 200
```
###  Change album details

* **Endpoint**
```
PUT    /albums/:id
```
* **Parameters**
```
@id:          [Integer] Required. Id of the album to be modified
@name:        [String]  Name of the album
@artist_id:   [Integer] Id of the artist associated to the album
@art_id:      [Integer] Id of the cover's art (image) for this album
@released_at: [Date]    Date the album was released
```
* **Response**
```
Type: Json
Keys:
  album: The modified album (with artist and songs)
  errors: ActiveRecord errors present on album edition, if any
  status: Http response code
Body:
  {
    album:
    {
        id: 1,
        name: 'album',
        art_id: 2,
        released_at: Fri, 28 Oct 2016,
        artist: { id: 2, name: 'artist, bio: 'some bio', alias: 'alias' },
        songs: [{ id: 3, name: 'song', duration: 3600, artist_id: 2 }]
    },
    errors: []
  }
  status: 200
```
###  Add songs to album

* **Endpoint**
```
POST   /albums/:album_id/songs/add?song_ids=[]
```
* **Parameters**
```
@album_id:  [Integer] Required. Id of the album songs will be added to
@song_ids:  [Array]   Required. List of song ids to be added to the album
```
* **Response**
```
Type: Json
Keys:
  album:  The resulting album with songs and artist
  errors: ActiveRecord errors present when adding songs, if any
  status: Http response code
Body:
  {
    album:
    {
        id: 1,
        name: 'album',
        art_id: 2,
        released_at: Fri, 28 Oct 2016,
        artist: { id: 2, name: 'artist, bio: 'some bio', alias: 'alias' },
        songs: [{ id: 3, name: 'song', duration: 3600, artist_id: 2 }]
    },
    errors: []
  }
  status: 200
```
###  Remove songs from album

* **Endpoint**
```
POST   /albums/:album_id/songs/remove
```
* **Parameters**
```
@album_id:  [Integer] Required. Id of the album songs will be removed from
@song_ids:  [Array]   Required. List of song ids to be removed from the album
```
* **Response**
```
Type: Json
Keys:
  album:  The resulting album with songs and artist
  errors: ActiveRecord errors present when adding songs, if any
  status: Http response code
Body:
  {
    album:
    {
        id: 1,
        name: 'album',
        art_id: 2,
        released_at: Fri, 28 Oct 2016,
        artist: { id: 2, name: 'artist, bio: 'some bio', alias: 'alias' },
        songs: [{ id: 3, name: 'song', duration: 3600, artist_id: 2 }]
    },
    errors: []
  }
  status: 200
```
###  Delete an album

* **Endpoint**
```
DELETE /albums/:id
```
* **Parameters**
```
@id:  [Integer] Required. Id of the album to be deleted
```
* **Response**
```
  status: 200
```
###  Get all playlists

* **Endpoint**
```
GET    /playlists
```
* **Parameters**

* **Response**
```
Type: Json
Array of playlists
Each album contains the artist and songs associated to it
Body
  [{
    id: 1,
    name: 'playlist',
    user_id: 2,
    songs: [{ id: 3, name: 'song', duration: 3600, artist_id: 4 }]
  }]
```
###  Get one playlist

* **Endpoint**
```
GET    /playlists/:id
```
* **Parameters**
```
@id:      [Integer] Required. Id of the playlist to be retrieved
```
* **Response**
```
Type: Json
Keys:
  playlist: The retrived playlist with its songs
  status: Http response code
Body
  {
    playlist:
    {
      id: 1,
      name: 'playlist',
      user_id: 2,
      songs: [{ id: 3, name: 'song', duration: 3600, artist_id: 4 }]
    }
  }
  status: 200
```
###  Create a playlist

* **Endpoint**
```
POST   /playlists
```
* **Parameters**
```
@name:        [String]  Required. Name of the playlist
@user_id:     [Integer] Required. Id of the playlist user (owner)
```
* **Response**
```
Type: Json
Keys:
  playlist:  The new playlist
  errors: ActiveRecord errors present on playlist creation, if any
  status: Http response code
Body:
  {
    playlist:
    {
      id: 1,
      name: 'playlist',
      user_id: 2,
      songs: []
    },
    errors: []
  }
  status: 200
```
###  Change playlist details

* **Endpoint**
```
PUT    /playlists/:id
```
* **Parameters**
```
@id:        [Integer] Required. Id of the playlist to be modified
@name:      [String]  Name of the playlist
@user_id:   [Integer] Id of the playlist user (owner)
```
* **Response**
```
Type: Json
Keys:
  playlist:  The modified playlist and its songs
  errors: ActiveRecord errors present on playlist creation, if any
  status: Http response code
Body:
  {
    playlist:
    {
      id: 1,
      name: 'playlist',
      user_id: 2,
      songs: [{ id: 3, name: 'song', duration: 3600, artist_id: 4 }]
    },
    errors: []
  }
  status: 200
```
###  Delete a playlist

* **Endpoint**
```
DELETE /playlists/:id
```
* **Parameters**
```
@id:  [Integer] Required. Id of the playlist to be deleted
```
* **Response**
```
status: 200
```
###  Add songs to playlist

* **Endpoint**
```
POST   /playlists/:playlist_id/songs/add
```
* **Parameters**
```
@playlist_id: [Integer] Required. Id of the playlist songs will be added to
@song_ids:    [Array]   Required. List of song ids to be added to the playlist
```
* **Response**
```
Type: Json
Keys:
  playlist: The resulting playlist with songs
  errors:   ActiveRecord errors present when adding songs, if any
  status:   Http response code
Body:
  {
    playlist:
    {
      id: 1,
      name: 'playlist',
      user_id: 2,
      songs: [{ id: 3, name: 'song', duration: 3600, artist_id: 4 }]
    },
    errors: []
  }
  status: 200
```
###  Remove songs from playlist

* **Endpoint**
```
POST   /playlists/:playlist_id/songs/remove
```
* **Parameters**
```
@playlist_id: [Integer] Required. Id of the playlist songs will be removed from
@song_ids:    [Array]   Required. List of song ids to be removed from the playlist
```
* **Response**
```
Type: Json
Keys:
  playlist: The resulting playlist with songs
  errors:   ActiveRecord errors present when adding songs, if any
  status:   Http response code
Body:
  {
    playlist:
    {
      id: 1,
      name: 'playlist',
      user_id: 2,
      songs: [{ id: 3, name: 'song', duration: 3600, artist_id: 4 }]
    },
    errors: []
  }
  status: 200
```
