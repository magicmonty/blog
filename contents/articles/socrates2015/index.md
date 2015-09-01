---
title: SoCraTes 2015 - or how to be catmatic
author: magicmonty
date: 2015-09-01 22:52
template: article.jade
category: Software Craftsmanship
disqus_category: 1836768
---

This year for the first time, I attended the [SoCraTes](https://www.socrates-conference.de/) (stands for Software Craftsmanship and Testing Conference)
in Soltau, Germany.

It is organized by the [Softwerkskammer](http://www.softwerkskammer.org), the Software Craftsmanship Communities in Germany.

I'm a member of this community since over 2 years now and heard a lot of good things about this conference.
This year I finally had the time and was also lucky enough to grab a ticket (yes you have to hurry, as the
number of participants is limited).

So let me give you some impressions of this awesome event:

**TL;DR it was really (yeah REALLY) awesome**
<span class="more"></span>

A really nice thing was, that the conference started already in advance of the event itself. How?
The conference organizers simply created a [Slack](https://slack.com/) team for all conference members.
So there was a nice way for the conference participants to organize themselves for all kinds of different
topics like rideshares to Soltau over alreding getting some feedback for session ideas to topics like
who wants to play board games in the evening or make music and many more.

Day 1
---
On the first day we arrived at the [Hotel Park](http://www.hotel-park-soltau.de/) in Soltau, our room keys, a
t-shirt and a name tag were already prepared, so we could get rid of our bags and to jump into the fray, as there
were already a lot of people there as we arrived.

An important thing I want to mention here, is that I felt immediately welcome by everyone I spoke to. Thats a
feeling I didn't had on other conferences yet. Another participant quoted it spot on as "Asshole free zone".
Thanks to everyone who made this happen

The conference began in the evening with a so called "World Cafe". For those who not know what this is, here
a short explanation:

All participants gather on different tables, which are prepared with a big "paper table cloth" to write on
and a lot of markers. First there is a short introduction round to get to know, who is who and what background
one has, then everyone can say what one expects from the conference and what one possible can contribute.
Everything is noted on the paper. After 20 minutes all people change randomly tables and a new round begins.
One person (the table owner) stays on the table and gives the new round a short indroduction what happened
on the last iteration. In total there were three rounds à 20 minutes. Through the mix of people on every table
a lot of ideas for sessions already emerged. I for example told the people on my table about [Live coding of music](http://lambdaphonic.de)
and got to my surprise so much reaction, that I proposed a session about it on the next day.

Day 2
---
The next two days were dominated by an Open Space which was facilitated by the wonderful [Pierluigi Pugliese](https://twitter.com/p_pugliese).
> An Open Space is an approach for hosting meetings, conferences, corporate-style retreats and community summit events,
> focused on a specific and important purpose or task – but beginning without any formal agenda, beyond the overall purpose or theme.
>
> [Wikipedia](http://en.wikipedia.org/wiki/Open_Space_Technology)

On the first day nearly 70 sessions were proposed, with topics of all kinds.

I attended a very interesting session about visual note taking and sketchnotes, hosted by [Markus Gärtner](https://twitter.com/mgaertne).
Then I hosted a session where I asked for an introduction into property based testing. Special thanks to [Nicole Rauch](http://twitter.com/nicolerauch)
and all the others in this session who helped me out here.

The next two sessions I participated were about tooling especially
[tmux](https://tmux.github.io) (hosted by [Thomas F. Nicolaisen](https://twitter.com/tfnico)) and [Vim](http://www.vim.org/)
(hosted by [Jan Ernsting](https://twitter.com/janernsting)). Both very interesting, especially I will give tmux a try
for my live coding sessions, as this provides me with an additional safety net, if I accidentally close my terminal
during a live coding performance ;).

Then came a session about teaching TDD with Google Spreadsheet for Kids, which quickly turned into a very fun
inversed Roman Numerals Kata with Google Spreadsheets (Google uses a subset of JavaScript as its macro language).
The nice thing here is, that you can get immediate feedback, as soon as you save your macro script.
It seems on the code retreat on sunday were a lot of people who adapted this for a game of life:

<div align="center">
<blockquote class="twitter-tweet" data-conversation="none" lang="en"><p lang="en" dir="ltr">Spreadsheet solutions for gol at <a href="https://twitter.com/hashtag/socrates15?src=hash">#socrates15</a> <a href="http://t.co/MRadkUldFn">pic.twitter.com/MRadkUldFn</a></p>&mdash; Wolfram Kriesing (@wolframkriesing) <a href="https://twitter.com/wolframkriesing/status/637973436174893056">August 30, 2015</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>
</div>
<div align="center">
<blockquote class="twitter-tweet" data-conversation="none" lang="en"><p lang="en" dir="ltr">More spreadsheet teams at the code retreat <a href="https://twitter.com/hashtag/socrates15?src=hash">#socrates15</a> <a href="http://t.co/pv9XdAQlKM">pic.twitter.com/pv9XdAQlKM</a></p>&mdash; Wolfram Kriesing (@wolframkriesing) <a href="https://twitter.com/wolframkriesing/status/637973789272375297">August 30, 2015</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>
</div>

The last session for day two I held myself about live coding in overtone ([german version on youtube](https://youtu.be/uAs05PTo6ug)).
I never suspected, that much interest. The room was packed and I got approached over the whole weekend on this topic.
Thanks to all for your interest.

Day 3
---
The third day began, like the previous day with a collective session, where one could propose the sessions for this day.
For this day I just want to highlight some of the sessions:

* Pragmatic Event Sourcing and CQRS (hosted by [Raimo Radczewski](Raimo Radczewski)) was very interesting to me. This is
  a topic I will definitively look into. Thanks for this.
* TDD does not lead to good design (hosted by [Sandro Mancuso](https://twitter.com/sandromancuso)). This session was a blast.
  The room was packed and Sandro explained his sight on the differences of classicist TDD and outside-in TDD and why
  he thinks that TDD itself does not lead to good design. Then he introduced his work on [Inflection Points](http://codurance.com/2015/06/17/inflection-point/).
  Thank you Sandro for this insights.
  <div align="center">
  <blockquote class="twitter-tweet" data-conversation="none" lang="en"><p lang="en" dir="ltr">Great talk by <a href="https://twitter.com/sandromancuso">@sandromancuso</a> about TDD and design today <a href="https://twitter.com/hashtag/socrates15?src=hash">#socrates15</a> <a href="http://t.co/Cb0ygKUvNc">pic.twitter.com/Cb0ygKUvNc</a></p>&mdash; Mario Loriedo (@mariolet) <a href="https://twitter.com/mariolet/status/637661176776761344">August 29, 2015</a></blockquote>
  <script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>
  </div>

Day 4
---
On the last day were some interesting workshops over the day for example a [code retreat](http://coderetreat.org/),
a workshop on functional programming and many more. Unfortunately the two days before were to much of an information
overload to me (and to less sleep), so I decided to go home in the morning.

Conclusion
---
* There were many more interesting sessions throughout this conference (for example [Be cat-matic](http://unclejamal.github.io/2015/08/31/catmatic.html) by [Pawel Duda](https://twitter.com/pawelduda))
  but one can unfortunately not see everything.
* The conference is not over after lunch. There was a lot of activitiy in the evening from people playing board games (hit of this year was [Exploding Kittens](http://www.explodingkittens.com))
  over [people making music](https://youtu.be/8XpB30AWE4Y), playing [Powerpoint Karaoke](https://en.wikipedia.org/wiki/Powerpoint-Karaoke),
  doing [TDD on a C64](http://64bites.com/episodes/014-tdd-with-macros/) to simply sitting on the bar and chatting.
* The sessions don't end on the pause. Here one meets and talks with interesting people, even on lunch and dinner.
* This was the absolute best conference I ever was and I hope I have the opportunity to go there nex year.

