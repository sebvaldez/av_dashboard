require 'uri'
require 'HTTParty'

# Creates
def zoomAPI( endpoint, params = {} )

	# Environment Vars
	apiKey = ENV['Zoom_API_Key']
	apiSecret = ENV['Zoom_API_Secret']

	baseUri = "https://api.zoom.us/"

	dataType = "data_type=JSON"

	results = Array.new

	# Adds Key, Secret and DataType to passed Array
	results = [
		"api_key=#{apiKey}",
		"api_secret=#{apiSecret}",
		"#{dataType}"
	]
	# ADD go through hash and push key and values to results array
	params.each do |key, value|

		results.push("#{key}=#{value}")
	end

	# Create and reurn one Url for HTTPARY to use
	url = "#{baseUri}" + "#{endpoint}" + "?" +  results.join('&')
	return url
end


# Get all zoom users
def zoomUsers
	
	page_number = 1

	userList = zoomAPI( 'v1/user/list', { :page_count=>30, :page_number=>page_number } )
	response = HTTParty.post(userList)
	response = response.parsed_response	

	results = response['users']
	# Loop to get all user count
	while response['page_number'] < response['page_count'] do

	 	page_number += 1

		userList = zoomAPI( 'v1/user/list', { :page_count=>30, :page_number=>page_number } )
		response = HTTParty.post(userList)
		response = response.parsed_response

		results += response['users']
	end
	return results
end










