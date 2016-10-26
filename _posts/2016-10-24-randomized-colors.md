---
title: Randomized color choices in SASS
tags: SASS, css, themes, programming
---

For a bit of variety, I decided to figure out how to generate a new front page header background and link colors whenever I rebuilt the blog (new posts, etc). This is still a static site, so no wizzy javascript stuff, I just wanted to do it in SASS.

This is what I came up with.

```sass
    $colors-list: (
      // background color, link color
      #DAE076 #AD5C55,
      #A9C9C5 #4A676D,
      #AD5C55 #5E7D68,
      #374768 #718A8A,
    );
    $color-index: random(length($colors-list));
    
    // Header description box
    $colors: nth($colors-list, $color-index);
    $header-desc-background-color: nth($colors, 1);
    // Link color
    $link-color: nth($colors, 2);
```

I may rework this as a map (dictionary) later on so I can add other theme-y things, but it was kinda fun to work out for now.
