require './lib/zoomAPI.rb'


SCHEDULER.every '5m', :first_in => 0 do |job|

	users = zoomAPI( 'user/list', { :page_size=>30, :page_number=>1 } )
	response = HTTParty.post(users)
	response = response.parsed_response

	totalUsers = response['total_records']
  send_event('total_users', {count: totalUsers} )
end