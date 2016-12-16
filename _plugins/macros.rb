#
# Embed a post in another, sort of like a tweet
#
# This implements a macro that you can use in the markdown content for a post to embed
#   a tweet-like rendering of another post. Adjust the template to include the full embed.content
#   to do a more Tumblr-style Redblog.
#
# Syntax: [[ embed_post url=/path/to/post.html ]]
#
# This form will look for an "embed.html" template in _includes. Template
#   should use "embed" as the post variable:
#
# <blockquote class="embed">
#     <img style="float: left" height="120" width="120" src="{{ embed.small_image }}">
#     <h2><a class="post-link" href="{{ embed.url | prepend: site.url }}}">{{ embed.title }}</a></h2>
#     <div style="font-style: italic;">
#         {{ embed.excerpt }}
#     </div>
#     <div style="clear:both"></div>
# </blockquote>
#
# [% embed_post url=/path/to/post.html template=fancy_embed.html %]
#
# This form will look for "fancy_embed.html" in _includes.
#

require 'liquid'

$registry = Hash.new

def register(name, &macro)
  $registry[name] = macro
end

def process_macros(payload)
  #
  # [[macro_name arg1=val arg2=val]]
  #
  re = /(\[\[[\s]*([\w_]+)[\s]*(.*?)[\s]*\]\])/
  content = payload.page.content
  site = payload.site
  out_content = "#{content}"

  content.scan re do |m|
    macro_text = m[0]
    puts m.to_a
    macro_name = m[1]

    puts macro_name
    if not $registry.key? macro_name
      # leave it sittin' right there in the text lookin' ugly
      next
    end

    arg_s = m[2]
    arg_h = Hash[ arg_s.scan(/([\w]+)=([\S]+)/).collect {
      |x| [x[0], x[1]]
    }]
    puts "processing #{macro_name}: #{arg_s}"
    output = $registry[macro_name].call(arg_h, payload)
    if not output.nil?
      puts "replacing #{macro_text} with #{output}"
      out_content.gsub! macro_text, output
    end
  end

  out_content
end

Jekyll::Hooks.register :posts, :pre_render do |post, payload|
  post.content = process_macros(payload)
  puts post.content
end

# register a macro
register("embed_post") do |arg_h, payload|
  puts arg_h
  #
  # this [[ embed_post ]] won't work
  #
  re = /\n[\s]*\[%[\s]*embed_post (.*?)[\s]*%\][\s]*\n/
  site = payload.site

  # where to find templates
  includes_dir = site['includes_dir']

  if not File.file?("#{includes_dir}/embed.html")
    puts "Could not find file: #{includes_dir}/embed.html"
    return content
  end

  embed_html = File.read("#{includes_dir}/embed.html")
  embed_t = Liquid::Template.parse(embed_html)

  # collect references to all the site posts and pages for lookup by url
  # this is fragile, I know.
  page_hash = Hash[ (site.posts + site.pages).collect {
      |x| [x.url, x]}]

  url = arg_h['url']
  puts "Found url: #{url}"

  if not arg_h['template'].nil?
    template = arg_h['template']
    puts "Found template parameter: #{template}"
    if File.file?("#{includes_dir}/#{template}")
      puts "Found #{includes_dir}/#{template}"
      embed_html = File.read("#{includes_dir}/#{template}")
      embed_t = Liquid::Template.parse(embed_html)
    else
      puts "Did not find #{includes_dir}/#{template}"
    end
  end

  page = page_hash[url]
  puts "No page with url #{url}." if page.nil?

  embed_rendered = nil
  if page
    embed_rendered = embed_t.render('embed' => page)
  end
  embed_rendered
end

