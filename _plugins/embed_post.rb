#
# Embed a post in another, sort of like a tweet
#
require 'liquid'

def embed_posts(payload)
  re = /\[% embed_post url=(.*) %\]/
  content = payload.page.content
  site = payload.site
  includes_dir = site['includes_dir']

  embed_html = File.read("#{includes_dir}/embed.html")
  embed_t = Liquid::Template.parse(embed_html)

  page_hash = Hash[ (site.posts + site.pages).collect {
      |x| [x.url, x]}]

  out_content = "#{content}"
  content.scan re do |m|
    url = m[0]
    puts "Found url: #{url}"

    page = page_hash[url]
    raise ArgumentError.new "No page with url #{url}." if page.nil?

    embed_rendered = embed_t.render('embed' => page)
    replace = "[% embed_post url=#{url} %\]"
    out_content.gsub! replace, embed_rendered
  end

  return out_content
end

Jekyll::Hooks.register :posts, :pre_render do |post, payload|
  post.content = embed_posts(payload)
end
