#
# Embed a post in another, sort of like a tweet
#
require 'liquid'

def embed_posts(payload)
  re = /\[%[\s]*embed_post (.*?)[\s]*%\]/
  content = payload.page.content
  site = payload.site

  includes_dir = site['includes_dir']

  embed_html = File.read("#{includes_dir}/embed.html")
  embed_t = Liquid::Template.parse(embed_html)

  page_hash = Hash[ (site.posts + site.pages).collect {
      |x| [x.url, x]}]

  out_content = "#{content}"
  content.scan re do |m|
    arg_s = m[0]
    arg_h = Hash[ arg_s.scan(/([\w]+)=([\S]+)/).collect {
      |x| [x[0], x[1]]
    }]
    url = arg_h['url']
    puts "Found url: #{url}"

    if not arg_h['template'].nil?
      template = arg_h['template']
      puts "Found template: #{template}"
      embed_html = File.read("#{includes_dir}/#{template}")
      embed_t = Liquid::Template.parse(embed_html)
    end

    page = page_hash[url]
    raise ArgumentError.new "No page with url #{url}." if page.nil?

    embed_rendered = embed_t.render('embed' => page)

    replace = "[% embed_post #{arg_s} %\]"
    out_content.gsub! replace, embed_rendered
  end

  return out_content
end

Jekyll::Hooks.register :posts, :pre_render do |post, payload|
  post.content = embed_posts(payload)
end
