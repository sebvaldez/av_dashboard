
#require 'httparty'
url = "http://14qjgk812kgk.statuspage.io/api/v2/scheduled-maintenances/upcoming.json"


#formatTime function

def fixTime (time)
	require 'date'
	time = DateTime.parse(time)
	time = time.strftime("%A, %d %b %l:%M %p")
	time 
end


SCHEDULER.every '30m', :first_in => 0 do |job|


maintenance = HTTParty.get(url)
maintenance = maintenance.parsed_response

maintenance = maintenance["scheduled_maintenances"][0]

upcoming = Hash.new
incidents = Hash.new

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



upcoming["incident_updates"][0].each do |key, val|
	incidents["#{key}"] = val
end

#puts incidents

print maintenance

  send_event('scheduled_main', { items: upcoming, incident: incidents } )


end