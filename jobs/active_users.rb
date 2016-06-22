require './lib/zoomAPI.rb'

SCHEDULER.every '2h', :first_in => 0 do |job|

# Create a To and From date string with in a billing cycle
now = Date.today()
to = Date.new(now.year, now.month, now.day + 1)
if now.day >= 16
	from = Date.new(now.year, now.month, 16)
else
	from = Date.new(now.year, now.month - 1, 16)
end


# Get active users for last billing cycle
if now.day >= 16
	prev_to = Date.new( now.year, now.month, 16)
	prev_from = Date.new( now.year, now.month - 1, 16)
else
	prev_to = Date.new( now.year, now.month - 1, 16)
	prev_from = Date.new( now.year, now.month - 2, 16)
end

pre_active_url = zoomAPI( 'report/getaccountreport', {
						:from=>prev_from,
						:to=>prev_to,
						:page_size=>30,
						:page_number=>1
					}
				 )
	# POST request for past AU
	past_response = HTTParty.post(pre_active_url)
	past_response = past_response.parsed_response
 	@past_active_users = past_response['total_records']



	# Create URL for Current active users Post
	url = zoomAPI( 'report/getaccountreport',
					{
						:from=>from,
						:to=>to,
						:page_size=>30,
						:page_number=>1
					}
				 )
	# POST request for curent AU
	response = HTTParty.post(url)
	response = response.parsed_response
	@active_users = response['total_records']
	
  send_event('active_users', { :count => @active_users } )
end




