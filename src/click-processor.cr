require "option_parser"

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

      puts process.wait.success? ? output : error
    end
  end
end
