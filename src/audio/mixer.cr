require "file"

class Mixer
  def initialize(files : Array(String))
    @files = files
  end

  def build_input_list : Array(String)
    input_arguments = [] of String

    @files.each { |file|
      input_arguments.push("-i")
      input_arguments.push("#{file}")
    }

    input_arguments
  end

  def mix(output_directory : String, output_filename : String)
    mix = Process.new(
      "ffmpeg",
      build_input_list +
      [
        "-filter_complex",
        "amix=inputs=" + @files.size.to_s + ":duration=longest:dropout_transition=0",
        "-ac",
        "-safe",
        "0",
        "#{output_directory}/#{output_filename}",
      ],
      output: Process::Redirect::Pipe,
      error: Process::Redirect::Pipe
    )

    error = mix.error.gets_to_end
    output = mix.output.gets_to_end
    success = mix.wait.success?

    if !success
      puts error
      exit
    end
  end

  def run(output_directory : String, output_filename : String)
    mix(output_directory, output_filename)
  end
end
