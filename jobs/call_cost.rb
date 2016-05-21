require './lib/zoomAPI.rb'

SCHEDULER.every '5m', :first_in => 0 do |job|

# Create a To and From date string with in a billing cycle
now = Date.today()
to = Date.new(now.year, now.month, 15)
from = Date.new(now.year, now.month - 1, 16)

# Call Records for last billing cycle

# First call
page_number = 1
url = zoomAPI( 'v1/report/getaudioreport',
			 {
			  	 :from=>from,
			 	 :to=>to,
			 	 :page_count=>30,
			 	 :page_number=>page_number
			 	}
			 )
response = HTTParty.post(url)
response = response.parsed_response

callRecords = response['telephony_usage']

# Loop to apprend all Telephony records from zoom INTO callRecords
while response['page_number'] < response['page_count'] do
	page_number += 1
	url = zoomAPI( 'v1/report/getaudioreport',
		{
		 :from=>from,
		 :to=>to,
		 :page_count=>30,
		 :page_number=>page_number
		}
	)
	response = HTTParty.post(url)
	response = response.parsed_response
	callRecords += response['telephony_usage']
end

call_out_cost  = 0
toll_free_cost = 0
count          = 0

# Calculate Costs for "Call-out" & "Toll-Free"
callRecords.each do |record|

	if record['type'] == "call-out"
		call_out_cost += record['total']
	elsif record['type'] == "toll-free"
		toll_free_cost += record['total']
	else
		count + 1
	end
end

 	# Round costs
	call_out_cost = "%2.f" % call_out_cost
	toll_free_cost = "%2.f" % toll_free_cost

	# Format To and From dates for widget
	formatTo = to.strftime("%A, %B %e, %G")
	formatFrom = from.strftime("%A, %B %e, %G")

	print "#{call_out_cost}"
	print "#{toll_free_cost}"

  send_event('phone_cost', { :to=> formatTo, :from=>formatFrom, :callOut => call_out_cost, :tollFree => toll_free_cost })
end








