require './lib/zoomAPI.rb'

SCHEDULER.every '1m', :first_in => 0 do |job|

	# Create a 'To' & 'From' for active user enpoint
	now = Date.today
	from = Date.new(now.year, now.month, 1)

	# Create URL for Post
	page_number = 1
	url = zoomAPI( 'v1/report/getaccountreport',
					{
						:from=>from,
						:to=>now,
						:page_sie=>30,
						:page_number=>page_number
					}
				 )

	response = HTTParty.post(url)
	response = response.parsed_response

	active_users = response['total_records']

  send_event('active_users', { :count => active_users })
end