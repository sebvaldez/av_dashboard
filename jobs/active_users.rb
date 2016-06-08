require './lib/zoomAPI.rb'

SCHEDULER.every '2h', :first_in => 0 do |job|

	# Create a 'To' & 'From' for active user enpoint for current Billing cycle
	now = Date.today
	to = Date.new(now.year, now.month, now.day)
	from = Date.new(now.year, now.month - 1, 16)

	# Create URL for Post
	page_number = 1
	url = zoomAPI( 'report/getaccountreport',
					{
						:from=>from,
						:to=>to,
						:page_sie=>30,
						:page_number=>page_number
					}
				 )
	response = HTTParty.post(url)
	response = response.parsed_response

	@active_users = response['total_records']

  send_event('active_users', { :count => @active_users } )
end