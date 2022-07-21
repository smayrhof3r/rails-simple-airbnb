class FlatsController < ApplicationController
  before_action :set_flat, only: [:show]

  TOKEN = "pk.eyJ1Ijoic21heXJob2ZlciIsImEiOiJjbDRyYmw1YWQwdXFyM2RuM3RwZjRxc2ttIn0.UytwmYqDnOC1BOBqMRCzvQ"
  def index
    @flats = Flat.all
  end

  def show
    set_map_api
  end

  private

  def set_flat
    @flat = Flat.find(params[:id])
  end

  def find_gps
    @token = "pk.eyJ1Ijoic21heXJob2ZlciIsImEiOiJjbDRyYmw1YWQwdXFyM2RuM3RwZjRxc2ttIn0.UytwmYqDnOC1BOBqMRCzvQ"

    Faraday.default_adapter = :net_http
    result = retrieve_gps
    @gps = result ? result["features"].first["geometry"]["coordinates"] : false
  end

  def retrieve_gps
    begin
      f = Faraday.get("https://api.mapbox.com/geocoding/v5/mapbox.places/#{@flat.address}.json?types=address&fuzzyMatch=true&autocomplete=true&limit=1&access_token=#{@token}")
      JSON.parse(f.body)
    rescue
      false
    end
  end

  def set_map_api
    find_gps

    if @gps
      @map_url = "https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/pin-l+f31212(#{@gps[0]},#{@gps[1]})/#{@gps[0]},#{@gps[1]},15,0/1200x300?access_token=#{@token}"
    else
      @map_url = "https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/pin-l+f31212(-0.091998,51.515618)/-0.091998,51.515618,15,0/1200x300?access_token=pk.eyJ1Ijoic21heXJob2ZlciIsImEiOiJjbDRyYmw1YWQwdXFyM2RuM3RwZjRxc2ttIn0.UytwmYqDnOC1BOBqMRCzvQ"
    end
  end
end
