

url = "https://14qjgk812kgk.statuspage.io/api/v2/summary.json"




# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '1m', :first_in => 0 do |job|

	# response = HTTParty.get(url)


	# components = response["components"]

	# test = []

	# 	components.each do |index|
			
	# 		test = index.delete_if {|x| x = index["group_id"] }
				
	# 	end
			
	#components.map { |x| puts x['group_id'] }

	# components.each do |index|

	# 	if index["status"] == "operational"
	# 		components['icon'] = 'Green Check'
	# 	else
	# 		components['icon'] = 'Red X'
	# 	end
	# end
	
	# print "new elements added from validation of status"
	# print "\n"
	# print components['icon']
	# print "\n"

	#send_event('zoom_c', { items: component } )

	#puts "Components have been fetched!"
 
end