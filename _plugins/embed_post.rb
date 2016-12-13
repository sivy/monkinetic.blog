#
# Embed a post in another, sort of like a tweet
#
# This implements a macro that you can use in the markdown content for a post to embed
#   a tweet-like rendering of another post. Adjust the template to include the full embed.content
#   to do a more Tumblr-style Redblog.
#
# Syntax: [% embed_post url=/path/to/post.html %]
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

def embed_posts(payload)
  # embed must be on a line by itself
  #
  # this [% embed_post %] won't work
  #
  re = /\n[\s]*\[%[\s]*embed_post (.*?)[\s]*%\][\s]*\n/
  content = payload.page.content
  site = payload.site
  out_content = "#{content}"

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

  content.scan re do |m|
    arg_s = m[0]
    arg_h = Hash[ arg_s.scan(/([\w]+)=([\S]+)/).collect {
      |x| [x[0], x[1]]
    }]
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

    replace = "[% embed_post #{arg_s} %]"
    if page
      embed_rendered = embed_t.render('embed' => page)

      puts "replacing #{replace} with #{embed_rendered}"
      out_content.gsub! replace, embed_rendered
    else
      puts "replacing #{replace} with ''"
      out_content.gsub! replace, ""
    end
  end

  return out_content
end

Jekyll::Hooks.register :posts, :pre_render do |post, payload|
  post.content = embed_posts(payload)
end
