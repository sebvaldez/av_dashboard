require './lib/zoomAPI.rb'


SCHEDULER.every '5m', :first_in => 0 do |job|

	totalUsers = zoomUsers
	totalUsers =totalUsers.size
	print totalUsers



  send_event('total_users', {count: totalUsers} )
end