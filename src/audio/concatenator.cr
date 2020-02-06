require "file"

class Concatenator
  RECIPE_FILENAME = "click-concatenator-recipe"
  @recipe : File

  def initialize(files : Array(String))
    @files = files
    @recipe = File.tempfile(RECIPE_FILENAME)
  end

  def build_recipe
    concatenationRecipe = "# Concatenation Recipe for Click. Generated at #{Time.utc} \n" + @files.map! { |file| "file '#{file}'" }.join("\n")

    File.write(@recipe.path, concatenationRecipe)
  end

  def concatenate(output_directory : String, output_filename : String)
    concat = Process.new(
      "ffmpeg",
      [
        "-f",
        "concat",
        "-safe",
        "0",
        "-i",
        @recipe.path,
        "-c",
        "copy",
        "#{output_directory}/#{output_filename}",
      ],
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
    build_recipe
    concatenate(output_directory, output_filename)
    cleanup
  end
end
