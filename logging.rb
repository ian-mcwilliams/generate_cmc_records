module Logging

  def self.output_message(message)
    puts message
    file = out_file
    file.write(message) if file
  end

  def self.out_file(out_file = nil)
    $out_file = out_file if out_file
    $out_file
  end

end