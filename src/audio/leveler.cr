require "file"

class Leveler
  def initialize(files : Array(String))
    @files = files
  end

  def level(output_directory : String)
    @files.each { |file|
      filename = file.split("/").last.chomp(".mp3")

      level = Process.new(
        "ffmpeg",
        [
          "-i",
          "#{file}",
          "-filter:a",
          "loudnorm",
          "-safe",
          "0",
          "#{output_directory}/#{filename}-leveled.mp3",
        ],
        output: Process::Redirect::Pipe,
        error: Process::Redirect::Pipe
      )

      error = level.error.gets_to_end
      output = level.output.gets_to_end
      success = level.wait.success?

      if !success
        puts error
        exit
      end
    }
  end

  def run(output_directory : String)
    level(output_directory)
  end
end
