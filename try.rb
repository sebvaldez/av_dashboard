## TEST 

require "httparty"

url = "https://14qjgk812kgk.statuspage.io/api/v2/summary.json"

response = HTTParty.get(url)

response = response.parsed_response

components = Hash.new

# Loop through Components Array indices and fix group_id: null
response["components"].each do |index|
	index["group_id"] = "OverWrote"
	# print index["group_id"]
end

response['components'].each do |index|
	if index['status'] == 'operational'
		index["icon"] = 'fa fa-check-circle'
	else
		index["icon"] = 'fa fa-exclamation-triangle'
	end
end

components = response['components']
print components
