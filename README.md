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
    Feature: [US1001] Arms Rockets After Boot

      In order to gain bargaining power with Super Hero
      An Evil Mastermind
      Wants visible evidence that the rockets have been armed

      ...

If there are any test cases, their steps get converted into Cucumber
steps:

    $ crab story show US1001
      ...
      @critical @automated @high
      Scenario: [TC10001] Rocket Silo Is Unlocked
        Given a silo where the rockets are stored
        When I boot the system
        The hatches should unlock

      ...

Some data about stories can also be edited straight from the command line.
In that sense, `crab` acts more like a command-line interface to Rally than a
bridge between Rally and Cucumber, but the team thought these were *very*
convenient features to have:

    $ crab story create "Secure Access to Flying Fortress Controls"
    US1004: Secure Access to Flying Fortress Controls (grooming)

    $ crab story update US1001 --name "Arms Rockets Upon Successful Boot" --state completed
    US1001: Arms Rockets Upon Successful Boot (completed)

    $ crab story delete US1004 # not in this movie :(
    Story US1004 deleted.

It is also possible to create, update and delete test cases inside Rally straight
from the command line:

    $ crab testcase create US1001 "Rocket Silo Is Unlocked"
    US1001/TC1501: Rocket Silo Is Unlocked (important medium automated acceptance)

    $ crab testcase update TC1501 --priority critical --risk low
    US1001/TC1501: Rocket Silo Is Unlocked (critical low automated acceptance)

    $ crab testcase delete TC1501
    Test case TC1501 deleted.

There are more switches. Try `crab --help` to find out more.

i18n Support
------------

`crab` uses [Gherkin][3] internally, so all languages supported by Cucumber are also
included:

    $ crab story show US1001 -l ja
    機能: [US1001] Arms Rockets Upon Successful Boot
    ...
    シナリオ: [TC1501] Rocket Silo Is Unlocked
      Given a silo where the rockets are stored
      ...

Unfortunately, we could not think of a decent way to translate the steps themselves
(see the `Given` there?), without using Gherkin to parse each step individually and
check that it can be used, which seemed a little overkill for now.

Hopefully this will be enough for your case, but if not please let us know!

[3]: https://github.com/cucumber/gherkin

Developing
----------

To develop `crab`, you are going to need [Bundler][4], [Aruba][5] and a
working Rally account with a project set up where you can edit things. The
supplied `Gemfile` should take care of everything else:

    $ git clone git@github.com:cv/crab.git
    $ cd crab
    $ bundle install
    $ rake

If you have any problems, please let us know.

[4]: http://gembundler.com
[5]: https://github.com/cucumber/aruba

To do / Roadmap
---------------

### 0.2.0

- `pull` is not very smart and could detect feature files being moved from one dir to another
- Recursively look for a `.crab` directory like Git does with `.git`
- Figure out how to stub or simulate Rally (tests are taking way too long already)

### 0.3.0

- Add a `push` subcommand which parses a Cucumber feature and adds or updates it in Rally
- Add a config command + .crab/config file to hold settings like project, etc
- Error messages are still more cryptic than we'd like
- Make it possible to associate defects with Features (essentially treating defects like stories)
- Use the Gherkin models and formatters instead of dumb string templates to generate feature files

### Later / before 1.0.0

- Encrypt password in generated `~/.crab/credentials`
- Add a Cucumber Formatter that updates Test Runs in Rally with results from CI
- Test in Ruby 1.9

### After 1.0.0

- Bash completion scripts

Suggestions? Please get in touch!

Authors and Contributors
------------------------

- Carlos Villela <cvillela@thoughtworks.com>
- Rodrigo Kochenburger <rkochen@thoughtworks.com>
- Fabio Rehm <frehm@thoughtworks.com>

And last but not least, Rodrigo Spohr <rspohr@thoughtworks.com> for the user testing.

Disclaimers
-----------

This project and its authors have no affiliation with Rally Software Development Corp. or the Cucumber project.

It was written as necessity in a real-world project, and by no means should represent endorsement of either product.

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
