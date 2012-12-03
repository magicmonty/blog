title: The Monty Test - A revised Joel Test
author: magicmonty
date: 2012-12-03 14:00
template: article.jade
category: Software Craftsmanship
disqus_category: 1836768

12 years ago, [Joel Spolsky][], Founder of [Fog Creek Software][] developed the so called [Joel Test][]. 

The purpose of these 12 questions is a test, if a company is able to create quality software. 
12 years is a long time and as a Software Craftsman I dont' agree with all of these questions anymore. So here is an updated proposal:

1. [Do you use (distributed) source control?][DoYouUseADvcs]
2. [Can you deploy your software in one step?][CanYouDeployInOneStep]
3. [Do you build on every commit?][DoYouBuildOnEveryCommit]
4. [Do you have a bug tracker which is connected to your source control system?][DoYouHaveABugTracker]
5. [Do you fix bugs before writing new code?][DoYouFixBugsBeforeWritingNewCode]
6. [Do you have short release cycles?][DoYouHaveShortReleaseCycles]
7. [Do you have a runnable spec?][DoYouHaveARunnableSpec]
8. [Can your developers work easily together?][CanYourDevelopersWorkEasilyTogether]
9. [Do you use the best tools money can buy?][DoYouUseTheBestToolsMoneyCanBuy]
10. [Do you have full time testers?][DoYouHaveFullTimeTesters]
11. [Do new candidates write code during their interview?][DoNewCandidatesWriteCodeDuringTheirInterview]
12. [Do you do usability testing with end users?][DoYouDoUsabilityTesting]

<!-- 
span class="more"></span
-->

So here are my thougths on this topic in a more detailed form:

### 1. Do you use (distributed) source control?<a id="DoYouUseADvcs"></a> ###
The original question was _"Do you use source control?"_. In 2012 this should be no question anymore. 
Teams without source control are simply not professional software developers. So the question was extended to "Do you use a DVCS?".
This should be a bonus point, as SVN should suffice too. If you see CVS, run...

### 2. Can you deploy your software in one step?<a id="CanYouDeployInOneStep"></a> ###
The original question was _"Can you make a build in one step?"_. The question targets Continuous Integration systems.
This should be extended to Continuous Deployment nowadays. This step also implies also having automatic acceptance tests (see also [question 7][DoYouHaveARunnableSpec]).

### 3. Do you build on every commit?<a id="DoYouBuildOnEveryCommit"></a> ###
The original question _"Do you make daily builds?"_ is a bit outdated. Builds should be made by your CI system on **EVERY.SINGLE.COMMIT**. Period.

### 4. Do you have a bug tracker which is connected to your source control system?<a id="DoYouHaveABugTracker"></a> ###
Here it is the same as with [question 1][DoYouUseADvcs]. The original question _"Do you have a bug database?"_ doesn't suffice anymore.
The Bugtracker you use should be able to communicate with your source control system and with other tools like code review systems to easily update bug states on commits and reviews.

### 5. Do you fix bugs before writing new code?<a id="DoYouFixBugsBeforeWritingNewCode"></a> ###
This is still up to date and should remain so. But this should be supported by [short release cycles][DoYouHaveShortReleaseCycles], TDD and continuous fearleass refactoring.

### 6. Do you have short release cycles?<a id="DoYouHaveShortReleaseCycles"></a> ###
The original question was here _"Do you have an up-to-date schedule?"_. I think this should be extended to _"Do you use agile techniques like SCRUM?"_ or in a more generic form
_"Do you have short release cycles?"_, as this takes this problem away from the programmer and moves it to a project manager. The point is here more to have a continuous communication about
the schedule (and what can be achieved within this schedule) with the stakeholder.

### 7. Do you have a runnable spec?<a id="DoYouHaveARunnableSpec"></a> ###
The original question _"Do you have a spec?"_ doesn't suffice for me. The specs in the form of user stories and epics should be executable through a tool like [Cucumber][] or [Fitnesse][].
The specs should be the acceptance tests too.

### 8. Can your developers work easily together?<a id="CanYourDevelopersWorkEasilyTogether"></a> ###
With the original question _"Do programmers have quiet working conditions?"_ I cannot agree at least not with [the description Joel Spolsky gives][Joel Test].
He writes that a developer is most productive if he is in "the flow" (or "the zone" if you like it better). I tend here to agree with [Uncle Bob][] in his book [The Clean Coder][], 
where he says that being in the flow can be productive for "boring" repeated work but dangerous for productive high quality programming where we need all our focus on the current topic.
In my opinion it is better to have a work environment, where developers can easily communicate and collaborate. That doesn't mean a big room stuffed with cubicles or worse none at all, but
small interconnected and easily accessable rooms with round tables where up to 4 developers can sit around and work together.

It gives a bonus point, if in the company a culture of pair programming is practiced.

### 9. Do you use the best tools money can buy?<a id="DoYouUseTheBestToolsMoneyCanBuy"></a> ###

### 10. Do you have full time testers?<a id="DoYouHaveFullTimeTesters"></a> ###

### 11. Do new candidates write code during their interview?<a id="DoNewCandidatesWriteCodeDuringTheirInterview"></a> ###

### 12. Do you do usability testing with end users?<a id="DoYouDoUsabilityTesting"></a> ###


[Joel Spolsky]: http://www.joelonsoftware.com "Joel Spolsky's blog"
[Fog Creek Software]: http://www.fogcreek.com/
[Joel Test]: http://www.joelonsoftware.com/articles/fog0000000043.html "The Joel Test on Joel Spolsky's blog"
[DoYouUseADvcs]: /articles/the-monty-test-a-revised-joel-test/#DoYouUseADvcs	"Do you use (distributed) source control?"
[CanYouDeployInOneStep]: /articles/the-monty-test-a-revised-joel-test/#CanYouDeployInOneStep	"Can you deploy your software in one step?"
[DoYouBuildOnEveryCommit]: /articles/the-monty-test-a-revised-joel-test/#DoYouBuildOnEveryCommit	"Do you build on every commit?"
[DoYouHaveABugTracker]: /articles/the-monty-test-a-revised-joel-test/#DoYouHaveABugTracker	"Do you have a bug tracker which is connected to your source control system?"
[DoYouFixBugsBeforeWritingNewCode]: /articles/the-monty-test-a-revised-joel-test/#DoYouFixBugsBeforeWritingNewCode	"Do you fix bugs before writing new code?"
[DoYouHaveShortReleaseCycles]: /articles/the-monty-test-a-revised-joel-test/#DoYouHaveShortReleaseCycles	"Do you have short release cycles?"
[DoYouHaveARunnableSpec]: /articles/the-monty-test-a-revised-joel-test/#DoYouHaveARunnableSpec	"Do you have a runnable spec?"
[CanYourDevelopersWorkEasilyTogether]: /articles/the-monty-test-a-revised-joel-test/#CanYourDevelopersWorkEasilyTogether	"Can your developers work easily together?"
[DoYouUseTheBestToolsMoneyCanBuy]: /articles/the-monty-test-a-revised-joel-test/#DoYouUseTheBestToolsMoneyCanBuy	"Do you use the best tools money can buy?"
[DoYouHaveFullTimeTesters]: /articles/the-monty-test-a-revised-joel-test/#DoYouHaveFullTimeTesters	"Do you have full time testers?"
[DoNewCandidatesWriteCodeDuringTheirInterview]: /articles/the-monty-test-a-revised-joel-test/#DoNewCandidatesWriteCodeDuringTheirInterview	"Do new candidates write code during their interview?"
[DoYouDoUsabilityTesting]: /articles/the-monty-test-a-revised-joel-test/#DoYouDoUsabilityTesting	"Do you do usability testing with end users?"
[Cucumber]: http://cukes.info "Cucumber home page"
[Fitnesse]: http://fitnesse.org "Fitnesse home page"
[Uncle Bob]: https://sites.google.com/site/unclebobconsultingllc "Robert C. Martin"
[The Clean Coder]: http://www.amazon.de/gp/product/0137081073/ref=as_li_qf_sp_asin_tl?ie=UTF8&camp=1638&creative=6742&creativeASIN=0137081073&linkCode=as2&tag=montyssamme-21 "The Clean Coder: A Code of Conduct for Professional Programmers (Robert C. Martin)"
