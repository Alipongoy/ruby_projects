require 'net/http'

class Website

	# This initializes @website if URI is provided.
	# PARAMETERS: STRING uri 
	# RETURNS: N/A
	def initialize(uri = "")
		if uri != ""
			self.uri_to_string(uri) 
		else
			return
		end
	end

	# This writes a string website to a text_file database.
	# PARAMETERS: URI 
	# RETURNS: N/A
	def uri_to_string(uri)
		@uri = URI(uri)
		@website = Net::HTTP.get(@uri)
	end

	# This selects only the useful selection of information.
	def parse_website
		puts @website
		@website.each_line do |code_line|
			puts code_line
		end
	end

	#// This writes a string website to a text_file database.
	#// PARAMETERS: N/A
	#// RETURNS: N/A
	def write_to_file()
		text_file = File.open("output.txt", "w") do |f|
			f << website
		end
		text_file.close()
	end
end

american_apparel = Website.new()
american_apparel.uri_to_string("http://store.americanapparel.net/en/men-s-new_cat33157")
american_apparel.parse_website
