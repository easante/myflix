Fabricator(:queue_item) do
  user
  video
  position Fabricate.sequence(:number, 1)
end
