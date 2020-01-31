require "dir"
require "path"
require "option_parser"
require "./audio/concatenator"

VERSION = "0.0.1"
directory = ""
output_filename = "mixdown-#{Time.utc}.mp3"

# Handle the passed options
OptionParser.parse do |parser|
  parser.banner = "Welcome to Click Processor"
  parser.on("-v", "--version", "Show Version") { puts "Version " + VERSION }
  parser.on("-h", "--help", "Show Help") { puts parser }
  parser.on("-d DIRECTORY", "--directory=DIRECTORY", "Concatenate all audio files in a directory") { |dir| directory = Path[dir].expand(home: true).to_s }
  parser.on("-o FILENAME", "--output=FILENAME", "The output filename") { |filename| output_filename = Path[filename].expand(home: true).to_s }
end

# Ensure we have a directory and at least something for the output filename
exit if directory.blank? || output_filename.blank?

# Process...
# 1. Get the MP3 files from the passed directory (removing the trailing slash if it has one)
audioFiles = Dir.glob(directory.chomp("/") + "/*.mp3")

# 2. Exit if we don't have any MP3 files to process
if audioFiles.empty?
  puts "There are no MP3 files in the specified directory."
  exit(1)
end

# 3. Concatenate the MP3 files and output the concatenated audio
Concatenator.new(audioFiles).run(output_filename)

# 4. Success message
puts "Success"
