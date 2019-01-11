class ZipcodeController < ApplicationController
  skip_before_filter :authenticate_user!

  def city_set
    city_name_part = params[:city].downcase
    zipcodes = Zipcode.where(or: [{ city: /^#{city_name_part}/ },
                                  { city: /^#{city_name_part.capitalize}/ }])
                      .uniq(&:city)
                      .first(5)
                      .map do |code|
                        code.attributes.merge({
                                                  state_abbr: code.state.try(:abbr),
                                                  state_name: code.state.try(:name)
                                              })
                      end
    render json: { data: zipcodes, status: 'Ok' }.to_json
  end

  def zip_set
    zipcodes = Zipcode.where(code: /^#{params[:zip]}/)
                      .uniq(&:code)
                      .first(5)
                      .map do |code|
                        code.attributes.merge({
                                                  state_abbr: code.state.try(:abbr),
                                                  state_name: code.state.try(:name)
                                              })
                      end
    render json: { data: zipcodes, status: 'Ok' }.to_json
  end
end
