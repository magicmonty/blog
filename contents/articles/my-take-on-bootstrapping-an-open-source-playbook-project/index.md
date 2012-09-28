title: My take on bootstrapping an open source playbook project
author: magicmonty
date: 2011-01-02 08:58
template: article.jade
category: Linux, PlayBook, Software-Projects, Air, Ant, Development, Git

For my first Air project for the [BlackBerry PlayBook](http://us.blackberry.com/developers/tablet/devresources.jsp) (more about it follows, when it is approved  ) I used the Adobe FlashBuilder 4. While this tool is quite comfortable to use in PlayBook development (especially the debugging capabilities), I’m not willing to pay 250 to 750$ for an IDE just to develop some free tools. This is simply not rentable.

The next thing is, that I wanted to have a possibility to build the project outside the IDE (already with CI in mind).

As a java developer my choice falls to [Apache Ant](http://ant.apache.org/bindownload.cgi) as a build tool and [Git](http://git-scm.com/) as version control.

So I created an Ant script and some templates, which bootstraps me a new Air project in a new GIT repository.

As a base for the template I used the build.xml template from [here](http://www.planetb.ca/2010/12/how-to-use-apache-ant-to-automate-blackberry-playbook-builds/).

I put it on [Github](https://github.com/magicmonty/playbook-template), so feel free to use and/or fork it.