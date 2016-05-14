require 'net/http'

class Website
	attr_accessor :item_array
	# This initializes @website if URI is provided.
	# PARAMETERS: STRING uri 
	# RETURNS: N/A
	def initialize(uri = "")
		@parsed_website = String.new()
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
		encountered_beginning = false
		@website.each_line do |code_line|
			if code_line.include?('<ul class="productGroup col-xs-12 no-padding">') 
				encountered_beginning = true
			end

			if encountered_beginning == true
				if code_line.include?('</ul>')
					encountered_beginning = false
				end
				@parsed_website << code_line
			end
		end
	end

	# This parses a parsed_website and turns it into parsed items.
	# PARAMETERS: N/A
	# RETURNS: N/A
	# MUTATES: @item_array
	def parse_items
		# Turn each li into individual objects
		encountered_beginning = false
		parsed_item = ""
		@item_array = []

		@parsed_website.each_line do |code_line|
			if code_line.include?('<li class="product col-xs-6 col-sm-4 product-grid-ad">') 
				encountered_beginning = true
			end

			if encountered_beginning == true
				if code_line.include?('</li>')
					encountered_beginning = false
					@item_array.push(parsed_item)
					parsed_item = ""
				end
				parsed_item << code_line
			end
		end
	end
	
	# This sorts out items in the @item_array
	def sort_items
		@product_array = []
		# This selects each item in item_array
		@item_array.each do |item|
			individual_item_array = item.split("\n")
			# This finds the name of the object
			name_index = individual_item_array.index('<div class="name">')
			name = individual_item_array[name_index+2]
			# This finds the price of the object
			price_index = individual_item_array.index('<div class="pricing">')
			price = individual_item_array[price_index+2]
			# This creates the product object
			product_holder = Product.new(name, price)
			@product_array.push(product_holder)
		end
	end

	# This writes a string website to a text_file database.
	# PARAMETERS: N/A
	# RETURNS: N/A
	def write_to_file
		text_file = File.open("output.html", "w") do |f|
			f << @parsed_website
		end
	end
end

class Product
	attr_accessor :name, :price
	def initialize(user_name, user_price)
		@name = user_name
		@price = user_price
	end
end

american_apparel = Website.new('http://store.americanapparel.net/en/men-s-new_cat33157')
american_apparel.parse_website
american_apparel.write_to_file
american_apparel.parse_items
american_apparel.sort_items