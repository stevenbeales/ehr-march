class ZipcodesController < BaseController

  def city_set
    zipcodes = Zipcode.where(city: /^#{params[:data][:city]}/)
                      .limit(5)
                      .map do |code|
                        code.attributes.merge({state_abbr: code.state.try(:abbr)})
                      end
    render json: zipcodes
  end

  def zip_set
    zipcodes = Zipcode.where(code: /^#{params[:data][:zip]}/)
                      .limit(5)
                      .map do |code|
                        code.attributes.merge({state_abbr: code.state.try(:abbr)})
                      end
    render json: zipcodes
  end
end
