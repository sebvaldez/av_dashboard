
# Upcoming maintenance 
url = "http://14qjgk812kgk.statuspage.io/api/v2/scheduled-maintenances/upcoming.json"


#formatTime function
def fixTime (time)
	require 'date'
	time = DateTime.parse(time)
	time = time.strftime("%A, %d %b %l:%M %p")
	time 
end


SCHEDULER.every '1m', :first_in => 0 do |job|

# Get and parse upcoming maintenance JSON
maintenance = HTTParty.get(url)
maintenance = maintenance.parsed_response

maintenance = maintenance["scheduled_maintenances"][0]

# Create empty hashed for loop below
upcoming = Hash.new
incidents = Hash.new

# puts key and values into the "Local" upcoming hash
if maintenance
	maintenance.each do |key, val|
		upcoming["#{key}"] = val
		#puts "key: #{key} val: #{val}"
	end

	#fix time formatted from JSON return
	upcoming["scheduled_for"] = fixTime(upcoming["scheduled_for"])
	upcoming["scheduled_until"] = fixTime(upcoming["scheduled_until"])

else 
	puts "there was an error"
end


# Put incidents array from upcoming in its own hash
upcoming["incident_updates"][0].each do |key, val|
	incidents["#{key}"] = val
end

  send_event('scheduled_main', { items: upcoming, incident: incidents } )
  puts "Maintenance & Incidents have been fetched!"

end