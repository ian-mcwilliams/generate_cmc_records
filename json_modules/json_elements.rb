module JsonElements

	def self.add_json_element(json, new_element)
		JSON.parse(json).merge(JSON.parse(new_element)).to_json
	end

end
