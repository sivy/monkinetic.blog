# define our macro
def embed_post(arg_h, payload)
  Jekyll.logger.debug("Running embed_post macro")
  Jekyll.logger.debug arg_h
  #
  # this [[ embed_post ]] won't work
  #
  re = /\n[\s]*\[%[\s]*embed_post (.*?)[\s]*%\][\s]*\n/
  site = payload.site

  # where to find templates
  includes_dir = site['includes_dir']

  if not File.file?("#{includes_dir}/embed.html")
    Jekyll.logger.warn "Could not find file: #{includes_dir}/embed.html"
    return content
  end

  embed_html = File.read("#{includes_dir}/embed.html")
  embed_t = Liquid::Template.parse(embed_html)

  # collect references to all the site posts and pages for lookup by url
  # this is fragile, I know.
  page_hash = Hash[ (site.posts + site.pages).collect {
      |x| [x.url, x]}]

  url = arg_h['url']

  if not arg_h['template'].nil?
    template = arg_h['template']
    Jekyll.logger.debug "Found template parameter: #{template}"
    if File.file?("#{includes_dir}/#{template}")
      Jekyll.logger.debug "Found #{includes_dir}/#{template}"
      embed_html = File.read("#{includes_dir}/#{template}")
      embed_t = Liquid::Template.parse(embed_html)
    else
      Jekyll.logger.warn "Did not find #{includes_dir}/#{template}"
    end
  end

  page = page_hash[url]
  Jekyll.logger.warn "No page with url #{url}." if page.nil?

  embed_rendered = nil
  if page
    embed_rendered = embed_t.render('embed' => page)
  end
  return embed_rendered
end


# register a macro
Jekyll::Hooks.register :site, :after_init, priority:10 do |site|
  puts site.config
  puts "registering embed_post macro"
  if not site.config.key? "macros"
    site.config["macros"] = Hash.new
  end
  site.config["macros"]["embed_post"] = method(:embed_post)
end

