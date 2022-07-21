class FlatsController < ApplicationController
  before_action :set_flat, only: [:show]
  def index
    @flats = Flat.all
  end

  def show
    @map = map_api
  end

  private

  def set_flat
    @flat = Flat.find(params[:id])
  end

  def find_gps
    @token = "pk.eyJ1Ijoic21heXJob2ZlciIsImEiOiJjbDRyYmw1YWQwdXFyM2RuM3RwZjRxc2ttIn0.UytwmYqDnOC1BOBqMRCzvQ"
    result = JSON.parse(URI.open("https://api.mapbox.com/geocoding/v5/mapbox.places/#{@flat.address}.json?access_token=#{token}").read)
    result ||= JSON.parse(URI.open("https://api.mapbox.com/geocoding/v5/mapbox.places/London.json?access_token=#{token}").read)
    @gps = result["features"].first["geometry"]["coordinates"]
  end

  def img_api
    "https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/pin-l+f31212(#{@gps[0]},#{@gps[1]})/#{@gps[0]},#{@gps[1]},10,0/300x200?access_token=pk.eyJ1Ijoic21heXJob2ZlciIsImEiOiJjbDRyYmw1YWQwdXFyM2RuM3RwZjRxc2ttIn0.UytwmYqDnOC1BOBqMRCzvQ"
  end
end
