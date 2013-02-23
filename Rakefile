require 'bundler'
Bundler.require

desc 'validates config'
task :validate do
	config = Nokogiri::XML(File.read('cruise-config.xml'))
	schema = Nokogiri::XML::Schema(File.read('cruise-config.xsd'))
	
	errors = schema.validate(config)
	unless errors.empty?
		puts errors.join("\n")
		fail
	end
end
