require "option_parser"
require "file_utils"
require "./concatenator"

module Click::Processor
  VERSION = "0.1.0"

  OptionParser.parse do |parser|
    parser.banner = "Welcome to Click Processor"

    parser.on "-v", "--version", "Show Version" do
      puts "version 0.0.1"
      exit
    end
    parser.on "-h", "--help", "Show Help" do
      puts parser
      exit
    end
    parser.on "-d DIRECTORY", "--directory=DIRECTORY", "Concatenate all audio files in a directory" do |directory|
      process = Process.new("ls", [directory], output: Process::Redirect::Pipe, error: Process::Redirect::Pipe)

      error = process.error.gets_to_end
      output = process.output.gets_to_end
      processSuccess = process.wait.success?

      if !processSuccess
        puts error
        exit
      end

      directoryContents = output.chomp.split("\n")

      directoryMp3Files = directoryContents.select! { |file| file.ends_with?(".mp3") }

      if directoryMp3Files.empty?
        puts "Sorry, there are no mp3 files in that directory."
      end

      Concatenator.new(directoryMp3Files, directory).run

      puts "Success!"
    end
  end
end
