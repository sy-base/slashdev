---
title: 'Terraform Deployment'
tags: ["linux", "vscode", "terraform", "nodejs", "gatsby", "aws" ]
published: true
date: '2020-06-27'
---

Well, I decided to do some additional work on my site. Initially I was going to set the deployment up using cloudformation, but after doing some other work using terraform for another cloud provider, I just feel like terraform makes a lot more sense and decided to use that instead. For this site I'm hosting the dns zone in route53 and using cloudfront as my web frontend. Cloudfront then uses an ec2 instance as it's origin server and since most of the page data is relatively static I think that should prevent the ec2 instance from taking too much traffic and falling over. I'm not likely to do any load tests though so I guess I won't really know unless my site gets popular for some reason. I've also started work on the deployment pipeline. I tend to do things manually at first just to make sure I understand how I want it to be setup, then slowly replace resources with an automated deployment. So step one is to replace ec2 instance, route53 record, and cloudfront resources with versions deployed using terraform. After I've completed that I'll validate my codebuild/codepipeline configuration and begin integrating these with terraform. Below is roughly what it should look like:<br><br>
Enduser access:<br>
route53 dns record -> cloudfront endpoint -> ec2 instance 

Deployment process:<br>
github source repo -> codepipeline -> codebuild -> codedeploy -> ec2 instance

All of the above will eventually be managed by terraform with github merges triggering the codepipeline. Obviously this is not a conventional architecture and lacks redudancy and scalability to some degree. However I'm definitely not trying to give all my money to amazon :P .. I think the cloudfront endpoint will handle most, if not all, of my capacity needs since the site design is basically static. In addition, the ability to destroy and create resources at will with terraform can offer some flexibilty in manually scaling if necessary or resolving issues quickly if the ec2 instance were to fail. Assuming I had a less limited budget I'd probably do something like this:<br><br>
Enduser access:<br>
route53 dns record -> cloudfront endpoint -> alb (load balancer) -> ec2 launch config + autoscaling

This architecture would provide a mode automated scaling and self-healing capability that honestly I don't really need right now. One of the great things about cloud though is when/if I do need to change my architecture it's easy and doesn't take very long. Something I've often heard in IT is cloud is just other peoples computers, and to some extent I definitely agree with that. The key difference though is a mature API with which to tell other peoples computers what you want. The automation is the key and I think that's lost on many people. Public cloud providers that offer well documented APIs to access their services are the ones that are succeeding, but I fear there are not enough of them. AWS alone runs an extremely large percentage of the internet right now and that should be a concern. I'm glad they are starting to finally get some excellent competition from Microsoft and Google (as well as some second tier providers) but more attention needs to be given to the open source development of private cloud software such as openstack. It was extremely popular at one point and seems to fallen off in popularity as far as I can tell. Who knows, maybe I'm wrong and openstack is still growing in popularity. If that's the case, great, but we still need a competitor to openstack and more companies should invest in private cloud technology.
<br>