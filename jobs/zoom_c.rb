

url = "https://14qjgk812kgk.statuspage.io/api/v2/summary.json"

# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '1m', :first_in => 0 do |job|

response = HTTParty.get(url)

response = response.parsed_response

components = Hash.new

# Loop through Components Array indices and fix group_id: null
response["components"].each do |index|
	index["group_id"] = "OverWrote"
	# print index["group_id"]
end

# Add icon class depending on status
response['components'].each do |index|
	if index['status'] == 'operational'
		index["icon"] = 'fa fa-check-circle'
	else
		index["icon"] = 'fa fa-exclamation-triangle'
	end
end

components = response['components']

send_event('zoom_c', { items: components } )

puts "Components have been fetched!"
 
end