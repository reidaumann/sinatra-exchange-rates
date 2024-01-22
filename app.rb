require "sinatra"
require "sinatra/reloader"
require "http"
require "json" 
# define a route


get("/") do

  # build the API url, including the API key in the query string
  api_url = "http://api.exchangerate.host/list?access_key=" + ENV.fetch("EXCHANGE_RATE_KEY")

  # use HTTP.get to retrieve the API information
  raw_data = HTTP.get(api_url)

  # convert the raw request to a string
  raw_data_string = raw_data.to_s

  # convert the string to JSON
  parsed_data = JSON.parse(raw_data_string)

  # get the symbols from the JSON
   @symbols = parsed_data.fetch("currencies").keys

  # render a view template where I show the symbols
   erb(:home)
end

get("/:from_curr") do
  @original_currency = params.fetch("from_curr")

  api_url = "http://api.exchangerate.host/list?access_key=#{ENV["EXCHANGE_RATE_KEY"]}"

  raw_data = HTTP.get(api_url)
  raw_data_string = raw_data.to_s
  parsed_data = JSON.parse(raw_data_string)
  @symbols = parsed_data.fetch("currencies").keys 

  erb(:from_curr) 
   
end

get("/:from_curr/:to_curr") do
  @original_currency = params.fetch("from_curr")
  @destination_currency = params.fetch("to_curr")

  api_url = "http://api.exchangerate.host/convert?access_key=#{ENV["EXCHANGE_RATE_KEY"]}&from=#{@original_currency}&to=#{@destination_currency}&amount=1"

  raw_data = HTTP.get(api_url)
  raw_data_string = raw_data.to_s
  parsed_data = JSON.parse(raw_data_string)
  @result = parsed_data.fetch("result")

  erb(:to_curr) 
  
end
