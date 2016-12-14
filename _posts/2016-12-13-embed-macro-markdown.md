---
title: Embedding Posts with Markdown Macros in Jekyll
date: 2016-12-13 8:30
---

I really wanted to be able to refer to previous posts on this site with a small 
embed, a bit like we embed tweets. Something like: 

[% embed_post url=/trump-v-my-relationships.html %]

That rendering is done inline by a plugin I wrote for jekyll, [Embed Post][plugin], with a macro like this:


    I really wanted to be able to refer to previous posts on this site with a 
    small embed, a bit like we embed tweets. 
    
    Something like: [% embed_post url=/trump-v-relationships.html %]


I have no idea if or how to release this to the community, for now I'm still iterating on features.

From the plugin comments:

	Embed a post in another, sort of like a tweet
	
	This implements a macro that you can use in the markdown content for a post 
	to embed a tweet-like rendering of another post. Adjust the template to 
	include the full embed.content to do a more Tumblr-style Reblog.
	
	Syntax: [% embed_post url=/path/to/post.html %]
	
	This form will look for an "embed.html" template in _includes. Template 
	should use "embed" as the post variable:
	
	<blockquote class="embed">
	    <img style="float: left" height="120" width="120" 
	         src="{{ embed.small_image }}">
	    <h2><a class="post-link" 
	           href="{{ embed.url | prepend: site.url }}}">{{ embed.title }}
	           </a></h2>
	    <div class="embed-content">
	        {{ embed.excerpt }}
	    </div>
	    <div style="clear:both"></div>
	</blockquote>
	
	Or: [% embed_post url=/path/to/post.html template=fancy_embed.html %]
	
	This form will look for "fancy_embed.html" in _includes.

Would love to have feedback from the community. Tweet or [email me](mailto:steveivy@gmail.com)!

[plugin]: https://gitlab.com/steveivy/steveivy.gitlab.io/blob/master/_plugins/embed_post.rb



