Factory.define(:song) do |a|
  a.name 'Lateralus'
  a.duration 15000
  a.guid SecureRandom.uuid
  a.association :artist
end
