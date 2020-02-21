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
    arguments = ["-m"] + @files + ["#{output_directory}/#{output_filename}"]

    mix = Process.new(
      "sox",
      arguments,
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
