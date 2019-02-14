require 'sinatra'
require 'json'

json_ifsc = Hash.new
json_by_city = Hash.new
json_error_message = Hash.new
@output = Hash.new
ar = []

json_error_message["errmsg"] = "Either Not Found OR Parameters Not stated Correctly"

get '/' do
      @output = json_error_message.to_json
      erb:app
end

