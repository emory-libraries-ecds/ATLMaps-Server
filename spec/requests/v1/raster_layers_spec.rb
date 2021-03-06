# frozen_string_literal: true

# The colors match the boxes shown in this Codepen: https://codepen.io/jayvarner/pen/NvmWaR
require('rails_helper')

RSpec.describe('V1::RasterLayers', type: :request) do
  fixtures :institutions, :raster_layers
  describe 'GET /raster_layers near auburn and hill - green box' do
    context 'focused on auburn and hill' do
      before { get '/raster-layers?search=true&bounds%5Bs%5D=33.75323758946669&bounds%5Bn%5D=33.757902813079326&bounds%5Be%5D=-84.37154531478883&bounds%5Bw%5D=-84.38896894454957' }
      it 'returns raster layers near auburn and hill' do
        expect(json).not_to(be_empty)
        expect(json.size).to(eq(12))
        expect([names]).to(contain_exactly(%w(lightblue purple wheat atlpp0355_131_blue black deeppink yellow atlpp0219_15_green atlpp0202_522_red atlpm0320_purple lime fuchsia)))
      end
    end
  end

  describe 'GET /raster_layers near reynoldstown' do
    context 'focused on reynoldstown - deeppink box' do
      before { get '/raster-layers?search=true&bounds%5Bs%5D=33.7430410068185&bounds%5Bn%5D=33.75406717933589&bounds%5Be%5D=-84.33897256851196&bounds%5Bw%5D=-84.36540842056276' }
      it 'returns raster layers in reynoldstown' do
        expect(json).not_to(be_empty)
        expect(json.size).to(eq(14))
        expect([names]).to(contain_exactly(%w(green atlpp0202_522_red black orange darkblue yellow atlpm0320_purple red brown purple atlpp0355_131_blue lime fuchsia atlpp0219_15_green)))
      end
    end
  end

  describe 'GET /raster_layers match lime' do
    context 'zoomed out to include all layers' do
      before { get '/raster-layers?search=true&bounds%5Bs%5D=34.07936423&bounds%5Bn%5D=33.50058196&bounds%5Be%5D=-84.06082848&bounds%5Bw%5D=-84.62628431&limit=18' }
      it 'returns raster layers within the lime bounds' do
        expect(json).not_to(be_empty)
        expect(json.size).to(eq(18))
        expect([names]).to(contain_exactly(%w(lime fuchsia pink grey atlpp0219_15_green atlpm0320_purple yellow gold black atlpp0202_522_red atlpp0355_131_blue darkred wheat purple darkviolet green brown atlpp0448_75_black)))
      end
    end
  end

  describe 'GET /raster_layers around emory' do
    context 'focused on emory' do
      before { get '/raster-layers?search=true&bounds%5Bs%5D=33.78298184257755&bounds%5Bn%5D=33.80061838317273&bounds%5Be%5D=-84.30071353912355&bounds%5Bw%5D=-84.34184789657594' }
      it 'returns raster layers near emory' do
        expect(json).not_to(be_empty)
        expect(json.size).to(eq(8))
        expect([names]).to(contain_exactly(%w(gold atlpp0219_15_green atlpp0355_131_blue atlpm0320_purple lime yellow fuchsia darkred)))
      end
    end
  end

  describe 'GET /raster_layers around poncey highland' do
    context 'focused on poncey highland' do
      before { get '/raster-layers?search=true&bounds%5Bs%5D=33.76844992095692&bounds%5Bn%5D=33.77443867330882&bounds%5Be%5D=-84.3503075838089&bounds%5Bw%5D=-84.35952365398408&zoom=18' }
      it 'returns raster layers within the lime bounds' do
        expect(json).not_to(be_empty)
        expect(json.size).to(eq(10))
        expect([names]).to(contain_exactly(%w(acs_wpa_td2_sheet30_yellow atlpp0355_131_blue atlpp0202_522_red black yellow atlpm0320_purple atlpp0219_15_green atlpp0448_75_black lime fuchsia)))
      end
    end
  end
end
