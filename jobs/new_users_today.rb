


SCHEDULER.every '20m', :first_in => 0 do |job|
  # Get year and month
  now = Date.today
  month = now.month
  year = now.year

  # request from zoom 
  url = zoomAPI( 'report/getdailyreport', { :year => year, :month => month})
  response = HTTParty.post( url )
  response = response.parsed_response

  # Get latest report
  newUserTotal = response['dates'].last

  send_event('new_users_today', {total: newUserTotal })
end