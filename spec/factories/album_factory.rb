Factory.define(:album) do |a|
  a.name 'Frogstomp'
  a.art_id 1
  a.guid SecureRandom.uuid
  a.released_at Date.today - 3.years
  a.association :artist
end
