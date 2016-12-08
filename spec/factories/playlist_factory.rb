Factory.define(:playlist) do |a|
  a.name 'Country music'
  a.guid SecureRandom.uuid
  a.user_id 1
end
