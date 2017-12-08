---
title: "New blog host: Netlify"
date: 2017-12-08 7:00
---

I love using Gitlab to manage the source of this site. It has all the feautres of Githab *I* use, and more. I've been hosting this site on Gitlab pages, using their build system to deploy this Jekyll site for the last couple of years. But (at least in my experience) Gitlab's CI system has been unreliable, with new posts or changes often refusing to deploy properly due to worker instability. Having this uncertainty (among other things) has killed a lot of my motivation to post or work on the site. Additionally, after my [Let's Encrypt](http://letsencrypt.com) certificate expired, I fought to get Jekyll to render the challenge file properly and I was just completely frustrated.

Enter [Netlify](http://netlify.com), which I had seen mentioned in my Twitter stream but had not investigated yet. I was able to log in to Netlify via my Gitlab account (Oauth++) and had my repo set up to build in a couple of minutes. Netlify worked out the Jekyll build command for me and the branch. I clicked build, skeptical that it was going to work out of the box. And work it did. The first build took 12 minutes (this site has many many posts). I was a bit worried that my long build times (a "feature" of Gitlab's new-docker-image-for-every-build CI system) were going to continue to haunt me.

On a hunch I tweaked my `jekyll build` command to add `--incremental` - a time-saving feature of jekyll that only rebuilds files that have changed. Gitlab never supported this option because every build was done in a fresh Docker container. I didn't know if Netlify would support it or not, but it was worth a shot. My next build time was two minutes, and the build log showed only 4 files re-uploaded. **BOOM**.

So good build times are good. What about my issue with Let's Encrypt and the certificate? I really wanted my site to be served over SSL - not so much for privacy as for identity verification. The first time I saw Netlify mentioned it was in the context of someone getting their site up on SSL, so I was hopeful. Indeed, Netlify's control panel had a simple HTTPS section, with built-in integration with Lets Encrypt. Once I had my DNS moved over to Netlify, the HTTPS setup took... oh, 2 minutes. And that included http->https redirection, and had the site set up to serve on monkinetic.blog as well as www.monkinetic.blog.

Color me impressed and I'm now a Netlify customer (well, it's free for individual use anyway, but YKWIM).

Anther feature I'm excited about is Preview Builds: I'm typing this right now into Gitlab's editor, and it's going to get committed to a new "preview" branch. If all goes well, Netlify will build the site to a new non-production server image for this branch, where I can preview the post before it goes live (yes, it's just a few paras of text but I often edit after seeing a post "in-situ").