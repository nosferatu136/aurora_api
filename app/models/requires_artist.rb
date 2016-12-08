module RequiresArtist
  private def artist_presence
    return if Artist.find_by_id(artist_id).present?
    errors.add(:base, 'Specified artist does not exist')
  end



  private def associate_artist_from_guid
    return unless artist_id.blank?
    artist = Artist.find_by_guid(artist_guid)
    self.artist_id = artist && artist.id
  end
end
