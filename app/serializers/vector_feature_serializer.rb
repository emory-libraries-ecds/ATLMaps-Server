# Serializer to expose attributes for Vector Features.
class VectorFeatureSerializer < ActiveModel::Serializer
    attributes :id,
               :geometry_type,
               :properties,
               :geojson,
               :filters,
               :name,
               :description,
               :images,
               :image,
               :youtube,
               :vimeo,
               :audio,
               :feature_id,
               :color_name,
               :color_hex
end
