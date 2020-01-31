class Concatenator
  @@recipe_filename = "click-concatenation-recipe.tmp"
  @@output_filename = "mixdown-#{Time.utc}.mp3"

  def initialize(files : Array(String), directory : String)
    @files = files
    @directory = directory
  end

  def build_recipe
    FileUtils.cd(@directory)
    FileUtils.touch(@@recipe_filename)

    concatenationRecipe = "# Concatenation Recipe for Click. Generated at #{Time.utc} \n" + @files.map! { |file| "file '#{FileUtils.pwd}/#{file}'" }.join("\n")

    File.write(@@recipe_filename, concatenationRecipe)
  end

  def concatenate(output_filename)
    concat = Process.new(
      "ffmpeg",
      [
        "-f",
        "concat",
        "-safe",
        "0",
        "-i",
        @@recipe_filename,
        "-c",
        "copy",
        output_filename,
      ],
      output: Process::Redirect::Pipe,
      error: Process::Redirect::Pipe
    )

    error = concat.error.gets_to_end
    output = concat.output.gets_to_end
    success = concat.wait.success?

    if !success
      puts error
      exit
    end
  end

  def cleanup
    FileUtils.rm("click-concatenation-recipe.tmp")
  end

  def run
    build_recipe
    concatenate(@@output_filename)
    cleanup
  end
end
