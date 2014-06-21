Fabricator(:invitation) do
  full_name { Faker::Name.name }
  email { Faker::Internet.email }
  token { Faker::Lorem.characters(16) }
  inviter_id { Faker::Number.digit }
  
  message { Faker::Lorem.paragraph(3) }
end
