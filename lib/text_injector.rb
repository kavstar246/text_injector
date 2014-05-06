require "text_injector/version"
require 'fileutils'

class TextInjector
  attr_reader :file
  attr_accessor :content, :identifier
  def initialize(options={})
    @options = options
    @file = @options[:file]
    raise "required :file option missing" unless @file
    @identifier = @options[:identifier] || default_identifier
    @content = @options[:content]
  end

  def run
    if File.exists?(@file)
      write_file(updated_file)
    else
      write_file(marked_content)
    end
  end

  def say(msg)
    puts msg unless @options[:mute]
  end

  def tmp_path
    "#{@file}.tmp"
  end

protected

  def default_identifier
    File.expand_path(@file)
  end

  def marked_content
    @marked_content = [comment_open, @content, comment_close].join("\n")
  end

  def read_file
    return @current_file if @current_file
    results = ''
    File.open(@file, 'r') {|f| results = f.readlines.join("") }
    @current_file = results
  end

  def write_file(contents)
    File.open(tmp_path, 'w') do |file|
      file.write(contents)
    end
    if @options[:tmp_file]
      say "Tmp file written to #{tmp_path}"
    else
      say "Updated #{@file}"
      FileUtils.mv(tmp_path, @file)
    end
  end

  def updated_file
    # Check for unopened or unclosed identifier blocks
    if read_file.index(comment_open) && !read_file.index(comment_close)
      warn "[fail] Unclosed indentifier; Your file contains '#{comment_open}', but no '#{comment_close}'"
      exit(1)
    elsif !read_file.index(comment_open) && read_file.index(comment_close)
      warn "[fail] Unopened indentifier; Your file contains '#{comment_close}', but no '#{comment_open}'"
      exit(1)
    end

    # If an existing identifier block is found, replace it with the content text
    if read_file.index(comment_open) && read_file.index(comment_close)
      read_file.gsub(Regexp.new("#{comment_open}.+#{comment_close}", Regexp::MULTILINE), marked_content)
    else # Otherwise, append the new content after
      [read_file, marked_content].join("\n\n")
    end
  end

  def comment_base
    "TextInjector marker for #{@identifier}"
  end

  def comment_open
    "# Begin #{comment_base}"
  end

  def comment_close
    "# End #{comment_base}\n"
  end

end