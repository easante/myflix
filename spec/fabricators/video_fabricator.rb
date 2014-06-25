Fabricator(:video) do
  title { Faker::Lorem.words(5).join(" ") }
  description { Faker::Lorem.words(10).join(" ") }
  category
#  large_cover 'public/tmp/monk_large.jpg'
#  small_cover 'public/tmp/monk.jpg'
#  video_url 'https://diikjwpmj92eg.cloudfront.net/uploads/week6/HW3%20watch%20video.mp4'
end
