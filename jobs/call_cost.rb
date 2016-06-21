require './lib/zoomAPI.rb'

SCHEDULER.every '25m', :first_in => 0 do |job|

# Create a To and From date string with in a billing cycle
now = Date.today()
to = Date.new(now.year, now.month, now.day + 1)
if now.day >= 16
	from = Date.new(now.year, now.month, 16)
else
	from = Date.new(now.year, now.month - 1, 16)
end

# Call Records for current Billing cycle
url = zoomAPI( 'report/getaudioreport',
			 {
					:from=>from,
					:to=>to,
					:page_size=>6000,
					:page_number=>1
			 	}
			 )
response = HTTParty.post(url)
response = response.parsed_response

callRecords = response['telephony_usage']
binding.pry
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
	call_out_cost = "%02.f" % call_out_cost
	toll_free_cost = "%02.f" % toll_free_cost

	# Format To and From dates for widget
	formatTo = to.strftime("%A, %B %e, %G")
	formatFrom = from.strftime("%A, %B %e, %G")

  send_event('phone_cost', { :to=> formatTo, :from=>formatFrom, :callOut => call_out_cost, :tollFree => toll_free_cost })

end








