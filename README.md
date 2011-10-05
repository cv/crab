crab: A Cucumber-Rally bridge
=============================

`crab` bridges the gap between stories specified, managed and tracked in
[Rally][1] and stories that are described and run as automated acceptance
and functional tests through [Cucumber][2].

It aims to provide seamless integration between both tools, allowing
people to communicate across these without much effort while trying to
stay out of the way as much as possible.

[1]: http://www.rallydev.com
[2]: http://cukes.info

Installing
----------

`crab` is distributed as a Ruby Gem. To install it, simply issue (where
`$` is your command prompt):

    $ gem install crab

And you should be good to go. To make sure everything is OK, try:

    $ crab -h

If you see a help message, everything went fine.

Usage
-----

As `crab` is still in its infancy, it doesn't support very complex
workflows, but does the job for the author and his team so far.

The team wrote a few stories directly in Rally before deciding that
writing them straight in Cucumber features would be better suited.
Initially, there were concerns around migration of the existing data.
Thankfully, that part is easy:

    $ crab login -u cv@lixo.org -p secr3t
    Credentials stored for cv@lixo.org.

    $ crab project "World Domination 3000"
    $ crab story find
    US1001: Arms Rockets Upon Successful Boot
    US1002: Launches Rockets Upon Command from Evil Mastermind
    US1003: Transfers $0.01 From All Bank Accounts
    ...

    $ crab story find Rockets
    US1001: Arms Rockets After Boot
    US1002: Launches Rockets Upon Command from Evil Mastermind

    $ crab story show US1001
    # language: en
    # state: grooming
    # fetched: 2011-10-04T13:32:35-03:00
    # revision: 17, by cv@lixo.org
    Feature: [US1001] Arms Rockets After Boot

      In order to gain bargaining power with Super Hero
      An Evil Mastermind
      Wants visible evidence that the rockets have been armed

      ...

Note the comments at the top of the file: language is relevant to
Cucumber, but all others are only to help keeping track of revisions
and changes.

If there are any test cases associated with that story, they get converted
into Cucumber scenarios:

    $ crab story show US1001
      ...
      # revision: 6, by cv@lixo.org
      @critical @automated @high
      Scenario: [TC10001] Rocket Silo Is Unlocked
        Given a silo where the rockets are stored
        When I boot the system
        The hatches should unlock

      ...

To convert a bunch of stories in one go, this pipe does the trick:

    $ crab story list --iteration "Iteration 7" | cut -f 1 -d : | xargs crab story pull

They will be saved inside `./features/grooming`, `./features/defined`,
etc. The reason for using subdirs named after the status is so that
stories can be fleshed out and their scenarios added, moved around and
completed without necessarily breaking the build for others.

To see if there have been any changes to a story in Rally, try this:

    $ crab story diff features/completed/US1010-safely-dispose-of-evidence.feature

Some data about stories can also be edited straight from the command line.
In that sense, `crab` acts more like a command-line interface to Rally
than a bridge between Rally and Cucumber, but the team thought these
were *very* convenient features to have.

Creating:

    $ crab story create "Secure Access to Flying Fortress Controls"
    US1004: Secure Access to Flying Fortress Controls (grooming)

Updating and moving:

    $ crab story update US1001 --name "Arms Rockets Upon Successful Boot" --state completed
    US1001: Arms Rockets Upon Successful Boot (completed)

    $ crab story move US1002
    US1002: Launches Rockets Upon Command from Evil Mastermind (completed)
    $ crab story move US1002
    US1002: Launches Rockets Upon Command from Evil Mastermind (accepted)
    # eek, found a few problems!
    $ crab story move US1002 --back
    US1002: Launches Rockets Upon Command from Evil Mastermind (completed)

Deleting:

    $ crab story delete US1004 # not in this movie :(
    Story US1004 deleted.

It is also possible to create, update and delete test cases inside Rally
straight from the command line:

    $ crab testcase create US1001 "Rocket Silo Is Unlocked"
    US1001/TC1501: Rocket Silo Is Unlocked (important medium automated acceptance)

    $ crab testcase update TC1501 --priority critical --risk low
    US1001/TC1501: Rocket Silo Is Unlocked (critical low automated acceptance)

    $ crab testcase delete TC1501
    Test case TC1501 deleted.

There are many more switches. Try exploring `crab --help` to find
out more.

Troubleshooting
---------------

This is still very rudimentary, but you can set `CRAB_LOG_LEVEL`
to one of the constants defined in `Logger` to see more output for
diagnosis. They are:

  - 0: DEBUG
  - 1: INFO
  - 2: WARN
  - 3: ERROR
  - 4: FATAL
  - 5: UNKNOWN

The default is `WARN`, which should be good enough for most day-to-day
usage, but if you are having trouble and would like to submit a bug
report, please try again with `CRAB_LOG_LEVEL` set to `0` or `1`:

    $ CRAB_LOG_LEVEL=0 crab story show US1001
    I, [2011-10-04T02:33:22.795535 #16754]  INFO -- crab: Getting credentials...
    I, [2011-10-04T02:33:22.795789 #16754]  INFO -- crab: Connecting to Rally as cvillela@thoughtworks.com...
    I, [2011-10-04T02:33:28.343039 #16754]  INFO -- crab: Looking up story with ID US1001
    I, [2011-10-04T02:33:31.861501 #16754]  INFO -- crab: US1001: 1 test case(s) found
    I, [2011-10-04T02:33:38.681445 #16754]  INFO -- crab: TC10001: 3 step(s) found
    ...

i18n Support
------------

`crab` uses [Gherkin][3] internally, so all languages supported by
Cucumber are also included:

    $ crab story show US1001 -l ja
    # language: jp
    # state: grooming
    # fetched: 2011-10-04T13:32:35-03:00
    # revision: 17, by cv@lixo.org
    機能: [US1001] Arms Rockets Upon Successful Boot
    ...
    シナリオ: [TC1501] Rocket Silo Is Unlocked
      Given a silo where the rockets are stored
      ...

Unfortunately, we could not think of a decent way to translate the steps
themselves (see the `Given` there?), without using Gherkin to parse each
step individually and check that it can be used, which seemed a little
overkill for now.

Hopefully this will be enough for your case, but if not please let us know!

[3]: https://github.com/cucumber/gherkin

Bash Completion
---------------

Rudimentary bash completion support is here. Enable it by running:

    $ . "`bundle show crab`/scripts/crab_bash_completion"

Tip: add it to your `.rvmrc` for effortless joy.

Developing
----------

To develop `crab`, you are going to need [Bundler][4], [Aruba][5]
and a working Rally account with a project set up where you can edit
things. The supplied `Gemfile` and the `cucumber:setup` task should take
care of everything else:

    $ git clone git@github.com:cv/crab.git
    $ cd crab
    $ bundle install
    $ rake cucumber:setup
    $ rake

If you have any problems, please let us know.

[4]: http://gembundler.com
[5]: https://github.com/cucumber/aruba

To do / Roadmap / Known Bugs
----------------------------

Please see the [issues page][6] page.

Suggestions? Please get in touch!

[6]: https://github.com/cv/crab/issues

Authors and Contributors
------------------------

- Carlos Villela <cvillela@thoughtworks.com> (@cv)
- Rodrigo Kochenburger <rkochen@thoughtworks.com> (@divoxx)
- Fabio Rehm <frehm@thoughtworks.com> (@fgrehm)

And last but not least, Rodrigo Spohr <rspohr@thoughtworks.com> and
Camilo Ribeiro <cribeiro@thoughtworks.com> for the user testing.

Disclaimers
-----------

This project and its authors have no affiliation with Rally Software
Development Corp. or the Cucumber project.

It was written as necessity in a real-world project, and by no means
should represent endorsement of either product.

Rally (c) 2003-2011 Rally Software Development Corp.

Cucumber (c) 2008-2011 Aslak Hellesøy et al.

License
-------

Copyright 2011 Carlos Villela <cvillela@thoughtworks.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
or implied.  See the License for the specific language governing
permissions and limitations under the License.
