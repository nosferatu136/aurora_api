module RequiresArtist
  private def artist_presence
    return if Artist.find_by_id(artist_id).present?
    errors.add(:base, 'Specified artist does not exist')
  end
end
