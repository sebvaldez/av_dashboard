require'./lib/zoomAPI.rb'

# Constants in Bill
constants = {
	:user_block => 32625.00,
	:large_meeting => 5773.90,
	:webinar_block => 9600.00,
	:room_connector_block => 490.00,
	:audio_commit_block	=> 3000.00,
	:cloud_block => 500.00
}

SCHEDULER.every '5h', :first_in => 0 do |job|

	# Create 'To' & 'From' for last bill cycle
	now = Date.today()

	# Should new apr 16 -> may 16
	from = Date.new(now.year, now.month - 2 , 16)
	to = Date.new(now.year, now.month - 1, 16)

	# Get some call records
	url = zoomAPI( 'report/getaudioreport', {:from=>from, :to=>to, :page_number=>1, :page_size=>6000} )
	response = HTTParty.post(url)
	total_records = response['total_records']

	telephony_records = response['telephony_usage']

	call_out_cost = 0.00
	toll_free_cost = 0.00
	sub_cost = 0.00
	bill_overages = 0.00

	if total_records > constants[:audio_commit_block] then 

		telephony_records.each do |record|
			if record['type'] == "call-out"
				call_out_cost += record['total']
			elsif record['type'] == "toll-free"
				toll_free_cost += record['total']
			end
		end

		items_cost = constants.values.reduce(:+)
		sub_cost = ( call_out_cost + toll_free_cost )
		bill_overages = (sub_cost - 3000.00 + items_cost )
		bill_overages = "%.02f" % bill_overages
	else
		estimated_cost = constants.values.reduce(:+)
		estimated_cost =  "%.02f" % estimated_cost

	end

	cpu = ( bill_overages.to_f / @active_users )
	cpu = "%.02f" % cpu

	totals = { :estimate => bill_overages, :costPerUser=>cpu}

  send_event('bill_estimate', { final: totals } )



end