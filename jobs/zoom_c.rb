

url = "https://14qjgk812kgk.statuspage.io/api/v2/summary.json"




# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '1m', :first_in => 0 do |job|

	response = HTTParty.get(url)

	response = response.parsed_response

	component = response["components"]

	indicate = response["status"]

	send_event('zoom_c', { items: component } )

	send_event('zoom_s', notice: indicate )

	puts "component has been fetched!"
 
end