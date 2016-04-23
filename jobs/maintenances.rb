require 'httparty'

url = "http://14qjgk812kgk.statuspage.io/api/v2/scheduled-maintenances/upcoming.json"




# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '1m', :first_in => 0 do |job|

	response = HTTParty.get(url)

	response = response.parsed_response







  send_event('scheduled_main', { })
end