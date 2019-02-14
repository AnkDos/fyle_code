require 'sinatra'
require 'json'
require 'csv'

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

get "/ifsc/:ifsc" do
    ifsc = params[:ifsc].to_s
    found = false
    CSV.foreach("csv/bank_branches.csv" , :encoding => 'windows-1251:utf-8') do |vals|
        if vals[0] == ifsc 
            json_ifsc["ifsc"] = vals[0]  
            json_ifsc["bank_name"] = vals[7]
            json_ifsc["bank_id"] = vals[1]
            json_ifsc["branch"] = vals[2]
            json_ifsc["address"] = vals[3]
            json_ifsc["city"] = vals[4]
            json_ifsc["district"] = vals[5]
            json_ifsc["state"] = vals[6]
            found = true
            break
        end
      end
    
      if found == true
        @output = json_ifsc.to_json
      else
        @output = json_error_message.to_json  
      end
      
end
