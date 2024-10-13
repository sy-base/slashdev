---
title: 'loooong week'
tags: ["codebuild", "aws" ]
published: '2020-07-02'
---

It's been a particular long week this week. Spent most of the week in GCP cloud training which honestly was great training. I was just slightly bored out of my mind because most of it was a compute enginer architecture course. So it was high level and I was familiar with almost all of the material already as I had spent the previous three weeks learning by doing. As part of an infrastructure team, one of our responsibilities it to provide "blessed" golden images other teams can you to deploy from, so I had already built a deployment pipeline in GCP using a combination of cloud schedule, cloud build, buckets, and compute engine. I had previously written a tool I called packer builder. It was meant to allow more flexibility by building packer templates dynamically to allow for the EXACT same automation that builds an image on vsphere, to be used in AWS, or Azure, or (in this case) GCP. Without packer builder I would have a large library of individual packer templates with duplicated code that would require tons of work updating any time I made a change to the build automation. Long story short most of my work over the last month has been around optimizing packer builder for cloud deployments and building a GCP image from scratch. With most of that out of the way and a long weekend I finally have some time to get back to my personal projects. For this site, while I technically have it deployed; updates are not automated. I started working on the buildspec required by codebuild to package up my site contents and place it on a bucket. It's pretty simplistic but lets go over it below:

<pre>
version: 0.2

phases:
  install:
    commands:
      - yum -y groupinstall "Development Tools"
      - yum -y install libglvnd-glx libXi
      - npm install -g gatsby
  build:
    commands:
      - npm install
      - gatsby build
artifacts:
  files:
    - '**/*'
  name: slashdev.org-$(date +%Y%m%d)
  </pre>

  So the buildspec is split into multiple sections after intially defining the version. When I first started using codebuild I was unfortunate enough to find examples using "version: 0.1" and when it didn't perform as expected this left me a bit puzzled until I read the very END of the documentation that detailed the differences. Essentially 0.1 is the first version and 0.2 has several important differences so I definitely recommend reading this first and really think this should be at the top of the document.

  https://docs.aws.amazon.com/codebuild/latest/userguide/build-spec-ref.html#build-spec-ref-versions

  I can't think of any good reason to use version 0.1, to be honest but I guess you never know. After the version you have mulitple sections, however I only use phases and artifacts. Phases are split into install, pre_build, build, and post_build. I think the names are pretty self explanatory but install is an optional phase used for installing packages required for your build.

<pre>
    install:
    commands:
      - yum -y groupinstall "Development Tools"
      - yum -y install libglvnd-glx libXi
      - npm install -g gatsby
</pre>

As you can see in my code above I use the install phase to install dependencies requires for gatsby, then use npm to install gatsby itself. After the install phase is pre_build, another optional phase that I did not make use of in this circumstance. This phase would be used to perform any steps required before you begin your build steps. The example the documentation gives is <i>"you might use this phase to sign in to Amazon ECR, or you might install npm dependencies."</i> Following the pre_build phase is the required build phase.
<pre>
 build:
    commands:
      - npm install
      - gatsby build
</pre>
