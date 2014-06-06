Fabricator(:review) do
  video_id 1
  user_id 1
  stars 3
  comment { Faker::Lorem.words(50).join(" ") }
end
