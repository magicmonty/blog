---
title: Introducing AutoTest for Delphi
author: magicmonty
date: 2011-09-30 18:31
template: article.jade
category: Software Craftsmanship,TDD,Delphi,Tools,Autotest,Software-Projects
disqus_category: 1836766
---

One of the main issues with doing [TDD](http://en.wikipedia.org/wiki/Test-driven_development) is the fact, that the cycle times between running the unit tests and the development of a feature has to be very short. In fact as short as possible.

In other languages there are always tools like [autotest](http://www.zenspider.com/ZSS/Products/ZenTest/) for ruby or [infinitest](http://infinitest.github.com/) or [JUnitMax](http://www.junitmax.com/) for Java.

I missed such a tool badly in Delphi, because it makes the development so much faster when the tests are running automatically in the background everytime the code has changed.

So I created [autotest4delphi](http://github.com/magicmonty/autotest4delphi). It uses [Growl](http://www.growlforwindows.com/gfw/default.aspx) as notify engine and outputs all relevant command line output of the compiler / test appropriately colored to the console and it’s configured via a simple INI-file.

The tool itself is written in Delphi 2006. I have not ported it yet to Delphi XE but this should not be a big problem.

Feel free to fork an use it.