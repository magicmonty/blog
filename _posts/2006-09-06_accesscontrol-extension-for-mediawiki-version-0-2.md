---
title: New version of the accesscontrol extension for MediaWiki
date: 2006-09-06 14:08
layout: post
categories:
- Software-Projects
- AccessControl
tags:
- Software-Projects
- AccessControl
- MediaWiki
disqus_category: 1836766
---

the extension can be downloaded under http://blog.pagansoft.de/download/accesscontrol-0.2.zip

<!-- more -->

The new version is tested on MediaWiki 1.6.8 und 1.7.1.

beside the adjustment for MediaWiki 1.7 there are some little bugfixes and changes:

* first of all: I switched to english for this article, so the international audience is better involved in the project
* I took the settings in an extra file (extensions/accesscontrolSettings.php) just to keep the LocalSettings.php clean
* there is a new Setting: $wgWikiVersion for switching between mediaWiki 1.6 and 1.7
* All users in the sysop-Group (the one from mediaWiki) can now see and edit the protected pages, so if you made a mistake, you can always correct it, even if the page is protected

There is still something to do like protection from edit and hiding the protected pages.

My original article with the last version can be found [here](http://blog.pagansoft.de/articles/seitenbasierte-gruppen-zugriffskontrolle-fuer-mediawiki).
