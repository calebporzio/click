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
      stdout = IO::Memory.new
      process = Process.run("ls", [directory], output: Process::Redirect::Pipe)
    end
  end
end
