module JsonElements

	def self.collate_json_elements(array_spec)
		json_blob = {}.to_json
		array_spec.each do |json_element|
			json_blob = JSON.parse(json_blob).merge(JSON.parse(json_element)).to_json
		end
		json_blob
	end

	def self.add_json_element(json, new_element)
		JSON.parse(json).merge(JSON.parse(new_element)).to_json
	end

end
