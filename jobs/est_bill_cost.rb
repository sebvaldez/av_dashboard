require'./lib/zoomAPI.rb'
require 'pry'

# Variables that are constant prices
constants = {
	:user_block => 32625.00,

	:large_meeting => 5773.90,

	:webinar_block => 9600.00,

	:room_connector_block => 490.00,

	:audio_commit_block	=> 3000.00,

	:cloud_block => 500.00
}

estimated_cost = ''
# Generate 'lastMonth' 16th and 'currentMonth' day for endpoints
now = Date.today()

from = Date.new( now.year, now.month - 1, 16 )
to = Date.new( now.year, now.month, now.day )


# Get Current Telephone usage Cost
phone_report_url = zoomAPI( 'v1/report/getaudioreport', {
	:from => from,
	:to => to,
	:page_size => 30,
	:page_number => 1
	} )

call_report = HTTParty.post( phone_report_url )
call_report = call_report.parsed_response

records = call_report['total_records']


# Logic if calls are more than 3k
if records > constants[:audio_commit_block].to_i then

	print "records are bigger than commitment!!"

else

	estimated_cost = constants.values.reduce(:+)
	estimated_cost =  "%.02f" % estimated_cost

end
binding.pry
# Get cost to a var

# Get all users that are currenly active

user_url = zoomAPI( 'v1/report/getaccountreport',
					{
						:from=>from,
						:to=>to,
						:page_sie=>30,
						:page_number=>page_number
					}
				 )
	active_list = HTTParty.post( user_url )
	active_list = active_list.parsed_response
	active_users = active_list['total_records']

# Divide Bill Estimate by Active users to = Cost Per User




SCHEDULER.every '1m', :first_in => 0 do |job|



  send_event('widget_id', { })
end