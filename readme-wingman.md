On Sat, Jan 14, 2023 at 2:49 PM James Grenning <james@wingman-sw.com> wrote:

I need to understand tagging a little
better

I've built web and
get this SHA and TAG

...

# to be added to my server before doing cyber-dojo
up

CYBER_DOJO_WEB_SHA=d164d9c75f8eabf294a043085cd404ad82b2f32f
CYBER_DOJO_WEB_TAG=d164d9c

...

Ok.

The SHA is the full sha of the commit.

The TAG is the first 7 characters of the this.

A common convention (which cyber-dojo uses) is to use the first 7 characters of the commit sha for the image tag.




james@ff-b-17:~/repos/github/cyber-dojo-web$ sudo docker images
REPOSITORY 
 
 
 
 
 
 
 
 
 
 
TAG 
 
 
 IMAGE ID 
 
 
 CREATED 
 
 
 
 
 
 
SIZE
cyberdojo/web 
 
 
 
 
 
 
 
 
 d164d9c 
 83b5dc823d20 
 About a minute ago 
 166MB
cyberdojo/web 
 
 
 
 
 
 
 
 
 latest 
 
83b5dc823d20 
 About a minute ago 
 166MB

I add my tag

james@ff-b-17:~/repos/github/cyber-dojo-web$ sudo docker tag cyberdojo/web jwgrenning/cyber-dojo-web
james@ff-b-17:~/repos/github/cyber-dojo-web$ sudo docker images
REPOSITORY 
 
 
 
 
 
 
 
 
 
 
TAG 
 
 
 IMAGE ID 
 
 
 CREATED 
 
 
 
 SIZE
cyberdojo/web 
 
 
 
 
 
 
 
 
 d164d9c 
 83b5dc823d20 
 3 minutes ago 
 166MB
cyberdojo/web 
 
 
 
 
 
 
 
 
 latest 
 
83b5dc823d20 
 3 minutes ago 
 166MB
jwgrenning/cyber-dojo-web 
 
 
 latest 
 
83b5dc823d20 
 3 minutes ago 
 166MB

jwgrenning/cyber-dojo-web does not show
d164d9c.

No.

I think what you want is

docker tag cyberdojo/web:d164d9c jwgrenning/cyber-dojo-web:d164d9c

Take the image name cyberdojo/web:d164d9c

Think of

- cyberdojo as being like the org name for a repo

- web as being like the name of the repo

- d164d9c as being like the short-sha of a git commit in the repo

A "full" docker image name also has a registry. If you leave this out

it defaults to dockerhub. This is where the image gets pushed to.

I can docker push
jwgrenning/cyber-dojo-web, and docker pull it on my server.

So...

$ docker push
jwgrenning/cyber-dojo-web

has two defaults

- the registry which is dockerhub

- the tag which becomes latest

So you've actually pushed

jwgrenning/cyber-dojo-web:latest

to dockerhub. Your org on dockerhub is jwgrenning.

The image name is cyber-dojo-web

It's tag has has defaulted to latest

on my cyberdojo
server I see this

root@wingman-ex-opt-2cpu-2022-07:~# docker images
REPOSITORY 
 
 
 
 
 
 
 
 
 
 
 
 
 TAG 
 
 
 IMAGE ID 
 
 
 CREATED 
 
 
 
 
SIZE
jwgrenning/cyber-dojo-web 
 
 
 
 
 
latest 
 
83b5dc823d20 
 14 minutes ago 
 166MB
jwgrenning/cyber-dojo-web 
 
 
 
 
 
 
 
d19d087f3130 
 17 hours ago 
 
 166MB

Do I need to add the
d164d9c to
jwgrenning/cyber-dojo-web?

Yes.




In an earlier build, I thought
d164d9c was the beginning of the IMAGE ID, which is ot the case now.

No. The tag is always at the end after the colon




Did I miss something or does all this look right and ready
for cyberdojo up?


If you have built a local image and what you see printed is

CYBER_DOJO_WEB_SHA=d164d9c75f8eabf294a043085cd404ad82b2f32f
CYBER_DOJO_WEB_TAG=d164d9c

Then you need to do this...

docker tag cyberdojo/web:d164d9c jwgrenning/cyber-dojo-web:d164d9c

Then

jwgrenning/cyber-dojo-web:d164d9c

has been pushed to dockerhub

Then, on your server...

docker pull jwgrenning/cyber-dojo-web:d164d9c

Now the image is on your server

Then

export CYBER_DOJO_WEB_IMAGE=jwgrenning/cyber-dojo-web

export CYBER_DOJO_WEB_TAG=d164d9c

Then

cyber-dojo up ...

Cheers

Jon

Cheers, James

On Sat, Jan 14, 2023 at 1:26 AM Jon Jagger <jon@jaggersoft.com> wrote:

Hi James

you also need to define the env-var for the new image name.

See https://github.com/cyber-dojo/cyber-dojo#overriding-the-default-rails-web-image

Cheers

Jon

On Fri, Jan 13, 2023 at 9:22 PM James W Grenning <james@wingman-sw.com> wrote:

Hi Jon

If I change the tag to jwgrenning/cyber-dojo-web (and nginx), I can push it to my docker hub, then pull it on my server. If I define CYBER_DOJO_WEB_SHA and CYBER_DOJO_WEB_TAG on my server will it ignore the TAG=jwgrenning/cyber-dojo-web

I'll probably try it in the morning.

Thanks, James

On 13 Jan 2023, at 12:32, Jon Jagger wrote:

On Fri, Jan 13, 2023 at 5:08 PM James W Grenning <james@wingman-sw.com> wrote:

Hi Jon

Thanks I'll look at that.

For the marker files, if I remove them from 'files' hash, will they not be saved with the other files?

Correct. They won't.

Cheers

Jon




Cheers, James

On 13 Jan 2023, at 10:42, Jon Jagger wrote:

Hi James

yes it was great :-)

In our session I was editing files in the web repo, then running ./demo.sh at the root of the web repo.

That was using the docker-compose.yaml file (also at the root of the repo) to bring up all the

services in their docker containers. The nginx container exposed port 80 so I could run cyber-dojo

from a browser on my laptop using http://localhost:80

So that was "a docker setup".

So I don't know what you mean by "A docker setup"....

Cheers

Jon

On Fri, Jan 13, 2023 at 2:13 PM James W Grenning <james@wingman-sw.com> wrote:

Hi Jon

Great spending time with you yesterday. Thank you!

Do you have a Docker setup for running cyber-dojo? I was going to make one, but thought you might have one.

Cheers, James

On 7 Jan 2023, at 1:34, Jon Jagger wrote:

Ok. That helps.

Can you tell me what the 3 patterns are.

I am interested in the idea you are looking into here in general.

It could become the basis of a feature that becomes part of cyber-dojo.

It seems there could be more than 3 patterns in the future.

So it makes me think...

1. there is limited space in a single traffic-light. Is there a way we could get more pixels to play with?

2. is it simpler to adopt a single extra visual distinction and provide a way to see what the mark means for each

traffic-light. Eg in the popup you get when you hover over a traffic-light.

3. the more patterns we get, the more important I think it is for the user to be able to

be able to easily find out what they mean

Cheers

Jon

On Fri, Jan 6, 2023 at 10:46 PM James Grenning <james@wingman-sw.com> wrote:

The three patterns are mutually exclusive.
 So there are 3 only

On Jan 6, 2023 at 4:03 PM, Jon Jagger <jon@jaggersoft.com> wrote:

Hi James

On Fri, Jan 6, 2023 at 8:21 PM James W Grenning <james@wingman-sw.com> wrote:

Jon

When you say a marker file, do you mean a file, of a specific name, that if it exists, means the traffic signal should be different than the stock colors?

Yes

I have three reasons for a different color. If I wanted each traffic signal inner pattern (you know the hollow and filled gray dots) to be different for each reason, would I want three marker files or could the content of the marker file be used to decide which pattern to use?

I hadn't realized there were three different possible new "colours/patterns"

If the patterns are A, B, C then you could have AB, BC, CA, A, B, C, ABC

So 7 combinations

That's quite a lot to try and show in a small traffic-light.

And quite a lot of new .PNG images to create if you want to differentiate them.

But to answer your question, I guess you could do it either way.

With one marker file with content, or separate marker files without content.

Either way, the idea I had was that they would all be deleted by the web service

and so never actually appear in the browser.

So from that perspective I suppose three separate marker files is simpler.

I thought I would get the marker files in place before we get started.

Good plan.

I am thinking I'll use a gray signal larger circle with the vertically aligned inner dots filled with red/amber/green to show each condition. -- BTW, I can live without differentiating the three, and there may be more than three asmy system evolves.

I'm not sure what you mean here.

I think you need to draw them on paper and send me a photo.

I presume you want something that is visible from a dashboard.

One more thing...

If I was a delegate on your course I think I would want some

kind of clear explanation of what these extra dots meant.

So it occurs to me this explanation could go in the marker

file and it does not get deleted.




Looking forward to meeting Thursday.

Me too

Cheers

Jon

James

On 6 Jan 2023, at 10:28, Jon Jagger wrote:

2pm - 5pm my time is a good fit...

Cheers

Jon

On Fri, Jan 6, 2023 at 3:19 PM James W Grenning <james@wingman-sw.com> wrote:

Thursday works for me next week. What times are good for you?

James

On 6 Jan 2023, at 0:23, Jon Jagger wrote:

Great. Let's put a date and time in our dairies.

What works for you next week?

Cheers

Jon

On Fri, Jan 6, 2023 at 3:33 AM James W Grenning <james@wingman-sw.com> wrote:

Hey Jon

Thanks for all the info. I know you did not suggest changing the red_amber_green.rb file. I wanted to see what would happen.

I'll poke around the things you suggested too. Pairing with you would be great on this, and just catching up.

Cheers, James

On 5 Jan 2023, at 14:32, Jon Jagger wrote:

Hi James

How are you returning :foobar ?

Is it directly from red_amber_green.rb ?

If so, for the reasons I stated in a previous email, I would _NOT_ do that.

(Please re-read that if you missed it.)

If you do that then :foobar will be seen as invalid in the runner service itself

and will be translated into :faulty (by runner) and then you will get the faulty dialog box.

I strongly recommend that you do not try modifying the runner service.

I would, again as detailed in a previous email, create a marker file in cyber-dojo.sh (with an echo).

I would NOT try tweaking red_amber_green.rb

Instead I would check for the marker file in the web service, delete it, and return :foobar (or something

more appropriate, see below) to the browser, from the web service.

The Javascript that gives the faulty dialog box is...

Here...

https://github.com/cyber-dojo/web/blob/master/app/views/kata/run_tests.js.erb#L74

I strongly recommend that you do not turn this off.

You are getting this dialog for the reasons I state above.

As far as I can tell from a quick look, if you do as I suggest...

Here... (note variable 'files' is returned from the runner service on line 22)

https://github.com/cyber-dojo/web/blob/master/app/controllers/kata_controller.rb#L19

Then the new "colour" will get to...

Here...

https://github.com/cyber-dojo/web/blob/master/app/assets/javascripts/cyber-dojo_lib_append_traffic_light.js#L51

and the browser will end up with an  html dom element with a src attribute of

"/images/traffic-light/${light.colour}.png"

where ${light.colour} will be what you end up setting...

Here...

https://github.com/cyber-dojo/web/blob/master/app/controllers/kata_controller.rb#L42

How to show this "green with a variation"?

You suggested a green with a dot inside it.

How about a traffic-light where the green _and_ amber bulbs are lit?

This is not a "real" traffic-light but red+amber is of course.

So it feels ok. To me at least.

Lastly, there is a widget (on the top right I think) that keeps count of the number of

occurrences of each colour. This will need, I think, some attention if you want

the sum of the individual counts to equal the total count.

My feeling is that the simplest initial thing for counting "green with a variation"

is that it counts as a green.

HTH

Cheers

Jon

P.S. Big thanks for the recent donation :-)

On Thu, Jan 5, 2023 at 6:07 PM James W Grenning <james@wingman-sw.com> wrote:

That did it.

I experimented with returning :foobar for my special colour. You won't be surprised that cyber-dojo choked on it giving me a "faulty traffic-light" dialog.

As it turns out, the timeline has a really good icon it in for not red-amber-green.

What would be handy for me, would be to turn off the "faulty traffic-light" dialog.

Is that something you could guide me to?

Again, not urgent, but very helpful.

James

On 5 Jan 2023, at 12:20, Jon Jagger wrote:

Yes a down and then an up.

Cheers

Jon

On Thu, Jan 5, 2023 at 5:05 PM James W Grenning <james@wingman-sw.com> wrote:

Kill the server?

With a cyber-dojo down then up? It seemed that an up alone made no difference. I'll retry it later.

Cheers, James

On 5 Jan 2023, at 2:30, Jon Jagger wrote:

Just kill the server and bring it back up.

Cheers

Jon

On Wed, Jan 4, 2023 at 10:57 PM James W Grenning <james@wingman-sw.com> wrote:

Looks like it is cached. Cat-ing the file shows it is the right file.

Is there a way to force a reload besides changing the name of the image?

Thanks, James

On 4 Jan 2023, at 15:52, Jon Jagger wrote:

Also, bear in mind that if you have a runner container

and you press [test] then this will bring the contents

of red_amber_green.rb into the cache for the runner container.

If you then edit red_amber_green.rb and rebuild the gcc image

but use the same image tag, then the runner service will

not see the new red_amber_green.rb because as far as it is

concerned, it has cached it already. The image name is its key.

So, in summary, you need to force a new runner container.

Cheers

Jon

On Wed, Jan 4, 2023 at 7:55 PM James Grenning <james@wingman-sw.com> wrote:

Hi Jon

I've been fiddling with red_green_amber.rb in my custom container for gcc.
 I can't seem to have
it take effect.

lambda { |stdout,stderr,status|

 output = stdout + stderr

 return :green if /But so what!/.match(output)

 return :red 
 if /Errors \((\d+) failures, (\d+) tests/.match(output)

 return :green if /OK \((\d+) tests, (\d+) ran/.match(output)

 return :amber
}

When I push test, and have "But so what!"in the file, but it does not change the output.

it makes me think this is coming from somewhere else.

Here is my dockerfile

FROM cyberdojofoundation/gcc:ee0bdcd
LABEL maintainer=james@wingman-sw.com

COPY install.sh .
RUN ./install.sh && rm ./install.sh
COPY red_amber_green.rb /usr/local/bin

RUN mkdir /fff
COPY fff.h /fff
RUN mkdir /wingman
COPY gen-xfakes.sh /wingman
COPY legacy-build.sh /wingman
COPY tdd-build.sh /wingman
COPY install.sh .

ENV TDD_BUILD /wingman/tdd-build.sh
ENV LEGACY_BUILD /wingman/legacy-build.sh
ENV CPPUTEST_HOME /cpputest

is red_amber_green in the right place?

Thanks, James

On Wed, Dec 14, 2022 at 4:35 PM James W Grenning <james@wingman-sw.com> wrote:

Hi Jon

Marry Christmas!
 I hope you are all well and the family is growing.

Mine is growing with grand babies 8 and 9 in the oven!

Cheers! James

James Grenning -- Author of Test-Driven Development for Embedded C

wingman-sw.com
blog.wingman-sw.com
@jwgrenning
facebook.com/wingman.sw

Join my live-via-the-web TDD Training

Mobile: +1 847-630-0998

">

James Grenning -- Author of Test-Driven Development for Embedded C

wingman-sw.com
blog.wingman-sw.com
@jwgrenning
facebook.com/wingman.sw

Join my live-via-the-web TDD Training

Mobile: +1 847-630-0998

">

James Grenning -- Author of Test-Driven Development for Embedded C

wingman-sw.com
blog.wingman-sw.com
@jwgrenning
facebook.com/wingman.sw

Join my live-via-the-web TDD Training

Mobile: +1 847-630-0998

James Grenning -- Author of Test-Driven Development for Embedded C

wingman-sw.com
blog.wingman-sw.com
@jwgrenning
facebook.com/wingman.sw

Join my live-via-the-web TDD Training

Mobile: +1 847-630-0998

">

James Grenning -- Author of Test-Driven Development for Embedded C

wingman-sw.com
blog.wingman-sw.com
@jwgrenning
facebook.com/wingman.sw

Join my live-via-the-web TDD Training

Mobile: +1 847-630-0998

James Grenning -- Author of Test-Driven Development for Embedded C

wingman-sw.com
blog.wingman-sw.com
@jwgrenning
facebook.com/wingman.sw

Join my live-via-the-web TDD Training

Mobile: +1 847-630-0998

">

James Grenning -- Author of Test-Driven Development for Embedded C

wingman-sw.com
blog.wingman-sw.com
@jwgrenning
facebook.com/wingman.sw

Join my live-via-the-web TDD Training

Mobile: +1 847-630-0998

James Grenning -- Author of Test-Driven Development for Embedded C

wingman-sw.com
blog.wingman-sw.com
@jwgrenning
facebook.com/wingman.sw

Join my live-via-the-web TDD Training

Mobile: +1 847-630-0998

">

James Grenning -- Author of Test-Driven Development for Embedded C

wingman-sw.com
blog.wingman-sw.com
@jwgrenning
facebook.com/wingman.sw

Join my live-via-the-web TDD Training

Mobile: +1 847-630-0998

James Grenning -- Author of Test-Driven Development for Embedded C

wingman-sw.com
blog.wingman-sw.com
@jwgrenning
facebook.com/wingman.sw

Join my live-via-the-web TDD Training

Mobile: +1 847-630-0998

">

James Grenning -- Author of Test-Driven Development for Embedded C

wingman-sw.com
blog.wingman-sw.com
@jwgrenning
facebook.com/wingman.sw

Join my live-via-the-web TDD Training

Mobile: +1 847-630-0998

James Grenning -- Author of Test-Driven Development for Embedded C

wingman-sw.com
blog.wingman-sw.com
@jwgrenning
facebook.com/wingman.sw

Join my live-via-the-web TDD Training

Mobile: +1 847-630-0998

">

James Grenning -- Author of Test-Driven Development for Embedded C

wingman-sw.com
blog.wingman-sw.com
@jwgrenning
facebook.com/wingman.sw

Join my live-via-the-web TDD Training

Mobile: +1 847-630-0998

James Grenning -- Author of Test-Driven Development for Embedded C

wingman-sw.com
blog.wingman-sw.com
@jwgrenning
facebook.com/wingman.sw

Join my live-via-the-web TDD Training

Mobile: +1 847-630-0998

">

James Grenning -- Author of Test-Driven Development for Embedded C

wingman-sw.com
blog.wingman-sw.com
@jwgrenning
facebook.com/wingman.sw

Join my live-via-the-web TDD Training

Mobile: +1 847-630-0998

James Grenning -- Author of Test-Driven Development for Embedded C

wingman-sw.com
blog.wingman-sw.com
@jwgrenning
facebook.com/wingman.sw

Join my live-via-the-web TDD Training

Mobile: +1 847-630-0998

">

James Grenning -- Author of Test-Driven Development for Embedded C

wingman-sw.com
blog.wingman-sw.com
@jwgrenning
facebook.com/wingman.sw

Join my live-via-the-web TDD Training

Mobile: +1 847-630-0998

75DED67B-A03E-4DF2-A56B-71E4B1401F9F
