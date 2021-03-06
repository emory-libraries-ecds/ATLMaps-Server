# frozen_string_literal: true

# app/controllers/api/v1/vector_features_controller.rb
class V1::VectorFeaturesController < ApplicationController
  include Permissions
  def show
    @feature = VectorFeature.find(params[:id])
    render(json: @feature)
  end

  def create
    factory = RGeo::Geographic.simple_mercator_factory
    geojson = params[:data][:attributes][:geojson]
    coordinates = geojson[:geometry][:coordinates]
    feature = VectorFeature.new(
      # TODO: Should this be in the model?
      properties: geojson[:properties],
      tmp_type: geojson[:geometry][:type],
      geometry_collection: factory.collection([factory.point(coordinates[0], coordinates[1])]),
      vector_layer: VectorLayer.find(params[:data][:relationships][:vector_layer][:data][:id])
    )
    # fampov.merge!(row['Cnsus Tract'].gsub(/[^0-9]/, ''): row['Percentage of Families in Poverty'])
    render(jsonapi: feature, status: :created) if feature.save
  end

  def update
    if admin?
      @layer_feature = VectorLayerFeature.find(params[:id])
      if @layer_feature.update(layer_params)
        # render json: @stop
        head(:no_content)
      else
        render(json: @layer_feature.errors, status: :unprocessable_entity)
      end
    else
      render(json: 'Bad credentials', status: :unauthorized)
    end
  end

  private

  def feature_params
    ActiveModelSerializers::Deserialization
      .jsonapi_parse(
        params,
        only: %i[
          geojson vector_layer properties
        ]
      )
  end
end
