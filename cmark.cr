require "markdown"
require "file"
require "dir"
require "option_parser"
require "colorize"

workpath = Dir.current
recursive = false

OptionParser.parse! do |parser|
  parser.banner = "  Usage: cmark [arguments]"
  parser.on("-r", "--recursive", "recursively find files") { recursive = true }
  parser.on("-d dir", "--directory=dir", "Specifies directory") { |dir| workpath = dir }
  parser.on("-h", "--help", "Show this help") {
    puts "\ncMark\n======\n\n"
    puts parser.colorize(:yellow)
    Process.exit
  }

  parser.invalid_option() { |err|
    puts "\n  #{err} is an invalid flag\n\n"
    puts parser.colorize(:yellow)
    Process.exit
  }

  parser.missing_option() { |err|
    puts "\n  #{err} is missing arguments\n\n"
    puts parser.colorize(:yellow)
    Process.exit
  }
end

if recursive
  globSearch = File.join(File.join(workpath), "**/**")
else
  globSearch = File.join(File.join(workpath), "**")
end

Dir.glob(globSearch) do |selected|
  if File.extname(selected) == ".txt"
    fileBaseName = File.basename(selected)
    currentDir = selected.split(fileBaseName)[0]
    fileName = fileBaseName.split(File.extname(selected))[0]
    saveFilePath = File.join(currentDir, "docs", "#{fileName}.html")
    compiled = Markdown.to_html(File.read(selected))
    compiledWithStyle = "#{compiled}"
    File.write(saveFilePath, compiledWithStyle)
    puts "#{selected} => #{saveFilePath}"
  end
end
