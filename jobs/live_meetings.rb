require './lib/zoomAPI.rb'


SCHEDULER.every '1m', :first_in => 0 do |job|

# Use Metic meetings endpoint
meetings = zoomAPI( 'v1/metrics/meetings', {:type=>1} )
meeting_response = HTTParty.post(meetings)

# Parse results
meeting_resonse = meeting_response.parsed_response
# Store total records from parsed JSON 
total_meetings = meeting_response['total_records']


# User Metrics Webinar meetings endpoint
webinar = zoomAPI( 'v1/metrics/webinars' , {:type=>1} )

webinar_response = HTTParty.post(webinar)

webinar_response = webinar_response.parsed_response

total_webinars = ''
unless webinar_response['meetings'].empty?
	total_webinars = webinar_response['total_records']
else
	total_webinars = "There are currenly no LIVE webinars"
end
	
	

  send_event('liveMeetings', { meetings: total_meetings, webinars: total_webinars })
end