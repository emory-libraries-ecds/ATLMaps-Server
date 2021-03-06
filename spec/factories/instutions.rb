# frozen_string_literal: true

# spec/factories/institutions.rb
FactoryBot.define do
  factory :institution do
    geoserver { Faker::Internet.url(host: 'geoserver.io', path: '/') }
    name { Faker::Movies::HitchhikersGuideToTheGalaxy.specie }
  end
end
