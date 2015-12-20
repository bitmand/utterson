# Utterson

Utterson is your friendly frontend/web editor for [Jekyll][jekyll] sites.

It is in a **very early state** at this point, please read about the features and the roadmap further down in this document.

## Get started

It's very simple to get started and test Utterson:

    git clone git@github.com:gabriel-john/utterson.git
    cd utterson
    bundle install --path vendor/bundle
    bundle exec rackup

Visit http://127.0.0.1:9292/ in your browser and you should see an empty list of Jekyll sites.

Either create a new one or copy/symlink an existing Jekyll site in the `sites/` directory:

    cd sites/
    ln -s ~/path/to/your/jekyll-site jekyll-site

## How to setup deploys of Jekyll sites within Utterson

Setting up deploy of the Jekyll site within Utterson requires a bit of manuel work. The information needed for deploy should be added to the Jekyll `_config.yml` file for the site. This is a complete example with 2 environments. All settings is mandatory, but you can ofcourse has as many environments as you like:

    utterson_deploy:
      staging:                                  # Environment name
        url: http://staging.example.com/        # URL to the environment
        confirm: false                          # Confirm deploy? Read more below
        description: Staging environment        # Simple description
        commands:                               # List of commands to be executed
        - jekyll build
        - rsync -a . user@some.server:/site/path
      production:
        url: http://www.example.com
        confirm: true
        description: Production environment
        commands:
        - jekyll build
        - git push

The `confirm` setting is a bit special. If false, the button to deploy an environment goes directly to deploy. But if true, an extra confirm click on a red button is neeeded before the deploy takes place.

## Requirements

Utterson is build using [Sinatra][sinatra] and read/writes data directly from the files in the Jekyll site directory, no external database is needed. Look at the Gemfile, it really is extremely boring.

It does however rely on [Git][git] and at this point expects the Jekyll sites to be checked into a git repository. New Jekyll sites created with Utterson will also be initialized with Git and all changes is committed as well.

## Features

Completed features at this point is:

 * Create new Jekyll site
 * Create/Edit/Delete Posts
 * Git integration ( all changes are committed )
 * View/Edit site settings
 * Deploy functionality

## Roadmap

Upcoming features in a non-prioritized list:

 * Rename Post
 * Post History ( git log )
 * Create/Edit/Delete/Rename/History Pages
 * Clone existing Jekyll site from Git repo
 * Add custom commit message to changes
 * Log deploys
 * Maybe consider adding tags to deploys ( or some other way of tracking which "version" is currently deployed in each environment )

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
