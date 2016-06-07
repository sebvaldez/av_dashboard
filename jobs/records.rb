require './lib/zoomAPI.rb'


SCHEDULER.every '15m', :first_in => 0 do |job|

	# Variables
	recording_users = ''
	standard_users = ''

	sum_of_users_in_group = ''
	total_users = ''

	msg = ''

	alert_class = ''

	# Get Zoom groups and their total_members
	url_for_groups = zoomAPI( 'v1/group/list')

	group_list = HTTParty.post( url_for_groups )
	group_list = group_list.parsed_response
	
	# Get lastest count of zoom users
	url_for_toal_users = zoomAPI( 'v1/user/list', { :page_count=>30, :page_number=>1 } )
	user_list = HTTParty.post( url_for_toal_users )
	user_list = user_list.parsed_response
	total_users = user_list['total_records']

	# GET current list of zoom rooms
	zrURL = zoomAPI( 'v1/metrics/zoomrooms', {:page_size=>30, :page_count=>1 } )
	response = HTTParty.post( zrURL )
	currentZoomoomCount = response['total_records']

	## FOR SOME REASON THE COUNT IS OFF BY TWO, SO I AM MAKING COUNT OF ZR - 2

	currentZoomoomCount = ( currentZoomoomCount - 2 )

	# Remove zoomRooms from total_users count (zoom rooms are not in  standard user group )
	total_users = ( total_users - currentZoomoomCount )

	# Total_Recording users
	group_list['groups'].map {|x| if x['name'] == "Recording" then recording_users = x['total_members'] end }

	# Total_Standard users
	group_list['groups'].map {|x| if x['name'] == "Standard User Group" then standard_users = x['total_members'] end }


	# Sum total from  groups
	sum_of_users_in_group = standard_users + recording_users

	if sum_of_users_in_group < total_users then

		msg = 'Not all users are in a group'
		alert_class = 'fix'
	else
		msg = 'All users are in a group'
		alert_class = 'healthy'
	end

	
	results = { 
		:standard_users => standard_users,
		:recording_users => recording_users,
		:current_users => total_users,
		:sum_users => sum_of_users_in_group,
		:message => msg,
		:class => alert_class
	}


  send_event('recorders', { result: results } )
end