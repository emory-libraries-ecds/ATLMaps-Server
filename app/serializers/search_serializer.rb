# frozen_string_literal: true

class SearchSerializer < RasterLayerSerializer
  # has_many :layers, embed: :ids
  # has_many :vectors, embed: :ids

  attributes :id
end
