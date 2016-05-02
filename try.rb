# ## this file should contain a class to 
#   connect to multiple different enpoints

class Connection
	require "httparty"

	attr_accessor version:, query:

	DEFAULT_BASE_URL = "https://api.zoom.us"

	DEFAULT_VERSON = "/v1"

	DEFAULT_QUERY

	def initialize(version: DEFAULT_VERSON, query: DEFAULT_QUERY)

		@connetion = self.Connection

	end

	private

	def api_key


		
	end


end
