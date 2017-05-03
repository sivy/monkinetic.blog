# require "markdown_macros/version"
require 'jekyll'
require 'kramdown'
require 'liquid'
require 'pp'

=begin rdoc
A simple macro processor for Markdown content in Jekyll.
=end
# module MarkdownMacros
=begin rdoc

= Macros for Markdown content in Jekyll

This implements a basic macro processor that you can use in the
markdown content for a post.

Syntax: <tt>[[ macro param=value ]]</tt>

Macros can be defined in Jekyll plugins and registered after the
Jekyll site is initalized by using the Jekyll
<tt>:site, :after_init</tt> hook:

  # register a macro
  Jekyll::Hooks.register :site, :after_init do |site|
    site.markdown_processor.register "silly_macro", method(:silly_macro_function)
  end

Short implementations (or any if you like the style) can be
registered as a block:

  # register a macro
  Jekyll::Hooks.register :site, :after_init do |site|
    site.markdown_processor.register "silly_macro" do |arg_h, payload|
      "Tis' a silly place."
    end
  end

@attr_reader [Hash] registry the macro registry

Author:: Steve Ivy (mailto:steveivy@gmail.com)
Copyright:: Copyright (c) 2016 Steve Ivy
=end
  class Jekyll::Converters::Markdown::MacroConverter <  Jekyll::Converters::Markdown

=begin rdoc
The registry is a Hash that maps macro names to Procs

<tt>{ name => &Proc, ... }</tt>
=end
    attr_reader :registry

    def initialize(config)
      @config = config
      pp config
    end

=begin rdoc
Register a macro (as a method)

When a macro is found in the post content, the Method or
block registered with that macro name will be called with:

- a Hash of the parameters that were passed in the macro
  call: `[[ mymacro param=value ]]`
- the payload object as passed to the macro processor

Eg:

  def mymacro(arg_h, payload)
    "macro content"
  do

  macroprocessor = MarkdownMacros::MacroProcessor.new

  macroprocessor.register("macro", method(:mymacro))

@param [String] name The name the macro function should be
    registered under. This is like a "tag name" and is the string
    that should appear in the macro in the post content (<tt>[[ name ]]</tt>)
@param [Method] macro a Method that implements the macro logic.
=end
    # def self.register(name, macro)
    #   @registry[name] = macro
    # end

=begin rdoc
Register a macro (as a block)

  macroprocessor = MarkdownMacros::MacroProcessor.new

  macroprocessor.register("macro") do |arg_h, payload|
    "macro content"
  end

@param [String] name The name the macro function should be
    registered under. This is like a "tag name" and is the string
    that should appear in the macro in the post content (<tt>[[ name ]]</tt>)
@yield [arg_h, payload] a block that implements the macro logic.
@yieldparam [Hash] arg_h Hash containing the params used in the macro call.
@yieldparam [Jekyll::Payload] payload context data from Jekyll used
    in rendering.
=end
    # def self.register_block(name, &macro_block)
    #   @registry[name] = macro_block
    # end

=begin rdoc
The main hook used to process macros. Replaces any macro
blocks (<tt>[[ macroname ]]</tt>) with the output of the
macro.

@param [Jekyll::Post] post the post that is being processed.
    We will operate on the <tt>post.content</tt>.
@param [Jekyll::Payload] payload a Jekyll payload object
    with the context for the post rendering, usable by macros.

=end
    def process_macros(content)
      #
      # [[macro_name arg1=val arg2=val]]
      #
      re = /(\[\[[\s]*([\w_]+)[\s]*(.*?)[\s]*\]\])/
      out_content = "#{content}"

      content.scan re do |m|
        macro_text = m[0]
        macro_name = m[1]

        puts "Looking for #{macro_name} in config:"
        puts @config['macros']
        if not @config['macros'].key? macro_name
          puts "Did not find #{macro_name}"
          # leave it sittin' right there in the text lookin' ugly
          next
        end

        arg_s = m[2]
        arg_h = Hash[ arg_s.scan(/([\w]+)=([\S]+)/).collect {
          |x| [x[0], x[1]]
        }]

        output = @config['macros'][macro_name].call(arg_h, @context)
        if not output.nil?
          out_content.gsub! macro_text, output
        end
      end

      out_content
    end

    def convert(content)
        puts "MacroProcessor.convert"
        puts @config
        content = process_macros(content)
        Kramdown::Document.new(content, @config).to_html
    end
  end
# end


# Jekyll::Hooks.register :site, :after_init, priority:30 do |site|
#   puts "Setting up macro_processor"
#   #site.class.module_eval { attr_accessor :macros }
#   site.data['macros'] = MarkdownMacros::MacroProcessor.new()
#   puts payload.site.data
#   Jekyll.configuration["test"] = "test"
# end


# Jekyll::Hooks.register :posts, :pre_render, priority:30 do |post, payload|
#   puts Jekyll.configuration["test"]
#   puts payload.site.data
#   post.content = payload.site.data["macros"].process_macros(post, payload)
# end
