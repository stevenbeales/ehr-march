namespace :parser do
  desc "Parse codes_diagnosises.txt"
  task diag_codes: :environment do
    text = File.open('codes_diagnosises.txt').read
    text.gsub!(/\r\n?/, "\n")
    text.each_line do |line|
      code = line.match(/^\w+/).to_s
      line.slice!(/#{code}\s+/)
      line.slice!(/\n$/)
      DiagnosisCode.create(code: code, description: line)

      message = "Codes: #{code} \r"
      print message
      $stdout.flush
    end
  end

end