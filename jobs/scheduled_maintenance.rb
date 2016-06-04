# Upcoming maintenance JSON URL ENPOINT
url = "http://14qjgk812kgk.statuspage.io/api/v2/scheduled-maintenances/upcoming.json"

SCHEDULER.every '3m', :first_in => 0 do |job|

# Get and parse upcoming maintenance JSON
maintenance = HTTParty.get(url)
maintenance = maintenance.parsed_response

# Create empty hashed for loop below
upcoming = Hash.new
incidents = Hash.new
unless maintenance["scheduled_maintenances"].empty?
	maintenance = maintenance["scheduled_maintenances"][0]
	# Puts key and values into the "Local" upcoming hash
	maintenance.each do |key, val|
		upcoming["#{key}"] = val
	end

	# Fix time formatted from JSON return
	upcoming["scheduled_for"] = fixTime(upcoming["scheduled_for"])
	upcoming["scheduled_until"] = fixTime(upcoming["scheduled_until"])

	# Put incidents array from upcoming in its own hash
	upcoming["incident_updates"][0].each do |key, val|
		incidents["#{key}"] = val
	end
else
	# Populate hashes if there is no maintence scheduled
	upcoming = { 'name'=> 'Maintenance', 'status'=> 'No upcoming maintenance', 'scheduled_for'=> 'none', 'scheduled_until'=> 'none'}
	incidents = { 'body'=> 'Zoom has returned that there will be no upcoming maintenance' }
end

send_event('scheduled_main', { items: upcoming, incident: incidents } )

end