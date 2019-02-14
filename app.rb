require 'sinatra'
require 'json'
require 'csv'

json_ifsc = Hash.new
json_by_city = Hash.new
json_error_message = Hash.new
json_final = Hash.new
@output = Hash.new
ar = []

json_error_message["errmsg"] = "Either Not Found OR Parameters Not stated Correctly"

get '/' do
      @output = json_error_message.to_json
      erb:app
end

get "/:ifsc1/:ifsc2" do
    ifsc1 = params[:ifsc1].to_s 
    ifsc = params[:ifsc2].to_s
    if ifsc1 == "ifsc"       
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

    else
        @output = json_error_message.to_json
    end

end

get "/:by_city/:bank_name/:city" do
    by_city = params[:by_city].to_s
    bank_name = params[:bank_name].to_s
    city = params[:city].to_s
    found = false
    if by_city = "by_city"
    CSV.foreach("bank_branches.csv" , :encoding => 'windows-1251:utf-8') do |vals|
        if vals[7] == bank_name && vals[4] == city 
            json_by_city["ifsc"] = vals[0]
            json_by_city["bank_name"] = vals[7]
            json_by_city["bank_id"] = vals[1]
            json_by_city["branch"] = vals[2]
            json_by_city["address"] = vals[3]
            json_by_city["city"] = vals[4]
            json_by_city["district"] = vals[5]
            json_by_city["state"] = vals[6]
            ar << json_by_city
            found = true
        end 
         json_by_city = Hash.new
    end
  
    else
        @output = json_error_message.to_json
    end     
        if found == true
          json_final["data"] = ar
          @output = json_final.to_json
        else
            @output = json_error_message.to_json
        end

end




