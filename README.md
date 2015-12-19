# Utterson

Utterson is your friendly frontend/web editor build in Ruby for [Jekyll][jekyll] sites.

It is in a **very early state** at this point, please read about the features and the roadmap further down in this document.

## Get started

It's fairly simple to get started and test Mister Hyde:

    git clone git@github.com:gabriel-john/utterson.git
    cd utterson
    bundle install --path vendor/bundle
    bundle exec rackup

Visit http://127.0.0.1:9292/ in your browser and you should see an empty list of Jekyll sites.

Either create a new one with the `Create Site` button or copy/symlink an existing Jekyll site in the `sites/` directory:

    cd sites/
    ln -s ~/path/to/your/jekyll-site jekyll-site

## Requirements

Utterson is build using [Sinatra][sinatra] and read/writes data directly from the files in the Jekyll site directory, no external database is needed. Look at the Gemfile, it really is extremely boring.

It does however rely on [Git][git] and at this point expects the Jekyll sites to be checked into a git repository. New Jekyll sites created with Utterson will also be initialized with Git and all changes is committed as well.

## Features

Completed features at this point is:

 * Create new Jekyll site
 * Create/Edit/Delete Posts
 * Git integration ( all changes are committed )
 * View/Edit site settings

## Roadmap

Upcoming features in a non-prioritized list:

 * Rename Post
 * Post History ( git log )
 * Deploy functionality ( changes are pushed and/or `jekyll build` )
 * Create/Edit/Delete/Rename/History Pages
 * Clone existing Jekyll site from Git repo
 * Add custom commit message to changes

Future features in a non-prioritized list:

 * File management ( [Jekyll static files][jekyll-files] )
 * A better markdown editor
 * Authors/editors/users build-in ( authentication etc. )
 * Background running tasks ( Sidekiq workers doing the dirty work )
 * Maybe make git integration optional

## Ideas/thoughts/bugs etc.

Please create an issue :)

[jekyll]:       http://jekyllrb.com/
[jekyll-files]: http://jekyllrb.com/docs/static-files/
[sinatra]:      http://www.sinatrarb.com/
[git]:          https://git-scm.com/
