# Tournament Results
Created by Dan Reardon as part of the Udacity Full Stack Web Developer Nanodegree.

## About
Python module that uses the PostgreSQL database to keep track of players and matches in a game tournament.

## How to Run
1. Install [Vagrant](https://www.vagrantup.com/).
2. Install [Virtual Box](https://www.virtualbox.org/).
3. Clone the [fullstack-nanodegree-vm repository](\https://github.com/udacity/fullstack-nanodegree-vm) to your local machine.
4. Replace the <code>tournament</code> folder within your fullstack-nanodegree-vm repository with this directory.
5. To use the Vagrant virtual machine, navigate to the full-stack-nanodegree-vm/tournament directory in the terminal, then use the command <code>vagrant up</code> (powers on the virtual machine) followed by <code>vagrant ssh</code> (logs into the virtual machine).
6. <code>cd /vagrant</code> to change directory to the [synced folders](http://docs.vagrantup.com/v2/getting-started/synced_folders.html) in order to work on your project.
7. Run the <code>tournament_test.py</code> file in order to test the code.

More information can be found in [this Getting Started guide](https://docs.google.com/document/d/16IgOm4XprTaKxAa8w02y028oBECOoB1EI1ReddADEeY/pub?embedded=true).

##File Descriptions
<code>tournament.sql</code> is used used to set up your database schema.

<code>tournament.py</code> is used to provide access to your database via a library of
functions which can add, delete or query data in your database to another Python program (a client program).

<code>tournament_test.py</code> is the test file given by Udacity. Run this file to test that everything functions correctly.

<code>README.md</code> is this file.