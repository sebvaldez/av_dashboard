require'./lib/zoomAPI.rb'

# Constants in Bill
constants = {
	:std_user => 21960.00,
	:lg_100 => 3500.00,
	:lg_200 => 3250.00,	
	:lg_300 => 1120.00,	
	:lg_500 => 1200.00,	
	:webinar_1000 => 680.00,
	:webinar_3000 => 990.00,
	:cloud_record_100gb => 500.00,
	:room_connector_block => 245.00,
	:audio_commit_block	=> 3000.00
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
	estimated_cost = 0.00
	cpu = 0.00

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
		estimated_cost = (sub_cost - 3000.00 + items_cost )
		estimated_cost = "%.02f" % estimated_cost

		cpu = ( estimated_cost.to_f / @active_users )
		cpu = "%.02f" % cpu
	else
		estimated_cost = constants.values.reduce(:+)
		estimated_cost =  "%.02f" % estimated_cost
		cpu = ( estimated_cost.to_f / @active_users )
		cpu = "%.02f" % cpu
	end
	print estimated_cost
	print "\n"
	print cpu
	totals = { :estimate => estimated_cost, :costPerUser=>cpu}

	### past active user goes here
	# it will user past active user and 
	#the previous to this current estimated cost

  send_event('bill_estimate', { final: totals } )

end



