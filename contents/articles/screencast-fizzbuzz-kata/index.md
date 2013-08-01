---
title: "Screencast: FizzBuzz kata"
author: magicmonty
date: 2013-07-31 21:40
template: article.jade
category: Screencast,Software Craftsmanship
disqus_category: 1836768
---

Yesterday, at the meetup of the [Softwerkskammer Rhein-Main](http://softwerkskammer.org/activities/treffen-20-softwerkskammer-rhein-main), we did a mini [code retreat](http://codreretreat.org)
with the [FizzBuzz kata](http://codingdojo.org/cgi-bin/wiki.pl?KataFizzBuzz). In advance I had a discussion with [Benjamin](http://www.squeakyvessel.com/), that this Kata could be a bit to easy for a code retreat. My point was here, that IMHO is not done completely. Most people stop on a function like this:

``` C#
public string Translate(int value)
{
    var result = string.Empty;

    if (value % 3 == 0)
        result += "Fizz";

    if (value % 5 == 0)
        result += "Buzz";

    if (value % 3 != 0 && value % 5 != 0)
        result += value.ToString();

    return result;
}
``` 

This is fine, as long you don't want to extend the kata with different rules. 

Imagine you got up to this point and now you get a new requirement:

*Extend the Translation function so it prints "Bang" for all values divisible by 7, "FizzBang" for values divisible by 3 and 7, "BuzzBang" for values divisible by 5 and 7 and "FizzBuzzBang" for values divisible by 3, 5 and 7*

Surely you could just add another if statement but how ugly is that.
This is the point, where the TDD-Part of the kata converts to a refactoring kata.

Here you can see my take on this kata.

It features a solution completely free of ```if``` statements and is quite good extendable. The resulting Translator class must never been touched anymore. All you have to do for different rules is to write a different RuleFactory. If you want to play you could even implement a RuleFactory which reads its rules from an XML file. 

The project for [Xamarin Studio](http://xamarin.com/) can be found [here](https://github.com/magicmonty/FizzBuzzKata-csharp).

You can get the music under http://www.jamendo.com/de/track/259936/scherzo-no.-4-in-e-major-op.-54-1843

Have Fun

<iframe style="margin: 0 auto;" width="480" height="360" src="http://www.youtube-nocookie.com/embed/7NISYoK-hfg?rel=0" frameborder="0" allowfullscreen=""></iframe>

[YouTube Link for mobile viewers](http://youtu.be/7NISYoK-hfg)
