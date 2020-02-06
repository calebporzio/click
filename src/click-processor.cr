require "dir"
require "path"
require "file_utils"
require "option_parser"
require "./audio/concatenator"
require "./audio/mixer"
require "./audio/leveler"

VERSION = "0.0.1"
directory = ""
output_directory = FileUtils.pwd.chomp("/")
output_filename = "mixdown-#{Time.utc}.mp3"

operations = {
  "concatenate" => false,
  "mix"         => false,
  "level"       => false,
}

# Handle the passed options
OptionParser.parse do |parser|
  parser.banner = "Welcome to Click Processor"
  parser.on("-v", "--version", "Show Version") { puts "Version " + VERSION }
  parser.on("-h", "--help", "Show Help") { puts parser }
  parser.on("-i DIRECTORY", "--input-directory=DIRECTORY", "Concatenate all audio files in a directory") { |dir| directory = Path[dir].expand(home: true).to_s.chomp("/") }
  parser.on("-d DIRECTORY", "--output-directory=DIRECTORY", "Set the output directory") { |dir| output_directory = Path[dir].expand(home: true).to_s.chomp("/") }
  parser.on("-o FILENAME", "--output=FILENAME", "The output filename") { |filename| output_filename = filename }
  parser.on("-c", "--concatenate", "Concatenate the files") { operations["concatenate"] = true }
  parser.on("-m", "--mix", "Mix the files") { operations["mix"] = true }
  parser.on("-l", "--level", "Level the audio files") { operations["level"] = true }
end

# Ensure we have a directory and at least something for the output filename
exit if directory.blank? || output_filename.blank?

# Ensure we only have one operation set
if operations.select { |key, value| value }.size > 1
  puts "You must specify whether you want to concatenate, mix or level the files."
  exit(1)
end

# Process...
# 1. Get the MP3 files from the passed directory (removing the trailing slash if it has one)
audioFiles = Dir.glob(directory + "/*.mp3")

# 2. Exit if we don't have any MP3 files to process
if audioFiles.empty?
  puts "There are no MP3 files in the specified directory."
  exit(1)
end

# 3. Concatenate or Mix the MP3 files and output the concatenated audio
if operations["concatenate"]
  Concatenator.new(audioFiles).run(output_directory, output_filename)
end

if operations["mix"]
  Mixer.new(audioFiles).run(output_directory, output_filename)
end

if operations["level"]
  Leveler.new(audioFiles).run(output_directory)
end

# 4. Success message
puts "Success"
