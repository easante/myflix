Fabricator(:friendship) do
  user_id { Faker::Number.number }
  friend_id { Faker::Number.number }
end
