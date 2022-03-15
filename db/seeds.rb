(1..50).each do |i|
  property = Property.create!(name: "#{i} - #{Faker::Address.unique.street_name}")

  rand(3..5).times do |_n|
    image_number = rand(1..14)
    property.images.attach(io: File.open(Rails.root.join("app/assets/images/seed/#{image_number}.jpg")), filename: "#{image_number}.jpg", content_type: 'image/jpg')
  end

  Kernel.puts "Propriedade #{i} criada com sucesso!"
end
