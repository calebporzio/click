require "file"

class Concatenator
  RECIPE_FILENAME = "click-concatenator-recipe"
  @recipe : File

  def initialize(files : Array(String))
    @files = files
    @recipe = File.tempfile(RECIPE_FILENAME)
  end

  def concatenate(output_directory : String, output_filename : String)
    arguments = @files.push("#{output_directory}/#{output_filename}")

    concat = Process.new(
      "sox",
      arguments,
      output: Process::Redirect::Pipe,
      error: Process::Redirect::Pipe
    )

    error = concat.error.gets_to_end
    output = concat.output.gets_to_end
    success = concat.wait.success?

    if !success
      puts error
      cleanup
      exit
    end
  end

  def cleanup
    @recipe.delete
  end

  def run(output_directory : String, output_filename : String)
    concatenate(output_directory, output_filename)
    cleanup
  end
end
