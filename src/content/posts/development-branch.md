---
title: 'Development Branch'
published: 2024-10-17T19:29:01-05:00
tags: [ "slashdev", "cicd", "development", "hugo" ]
draft: true
---
Recently created a develop branch for the site that is hosted via "dev.slashdev.org". My ability to create an entirely seperate development infrastructure is quite a bit limited by the cost I'm willing to spend for this project. That basically means some shared resources are required. While the production site has cloudfront hosting, the development site does not. Just an nginx virtualhost for the sub-domain dev.slashdev.org. When using hugo to statically generate the content, it allows me to render pages that are expired, published in the future, or still in draft. I can also change the site configuration (i.e. use a red theme) so it's easy for me to distringuish the development site from the production site. Simple design, and if the budget was higher I'd likely deploy an entirely different infrastructure via terraform for my development environment but this achieves my goals at a low cost.
