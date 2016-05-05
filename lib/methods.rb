## file to provide methods


# FormatTime function
def fixTime (time)
	require 'date'
	time = DateTime.parse(time)
	time = time.strftime("%A, %d %b %l:%M %p")
	time 
end