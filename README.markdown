# Heroku - Mongo Sync

This is a plugin for the Heroku command line, adding commands to sync your
local and production mongo databases.

It was tested and should just work with Mongo HQ. If you host your mongo db
somewhere else, just make sure you have access from your local machine.

## Installation

    $ heroku plugins:install http://github.com/pedro/heroku-mongo-sync.git

## Config

The plugin assumes your local mongo db is running on your localhost with the
standard settings (port 27017, no auth). It will use a database named after
the current Heroku app name.

You can change any of these defining the URL it should connect to, like:

    export MONGO_URL = mongo://user:pass@localhost:1234/db

For production, it will fetch the MONGO_URL from the Heroku app config vars.

## Usage

Get a copy of your production database with:

    $ heroku mongo:pull
    Replacing the myapp db at localhost with genesis.mongohq.com
    Syncing users (4)... done
    Syncing permissions (4)... done
    Syncing plans (17)... done

Update your production database with:

    $ heroku mongo:push
    THIS WILL REPLACE ALL DATA FOR myapp ON genesis.mongohq.com WITH localhost
    Are you sure? (y/n) y
    Syncing users (4)... done
    Syncing permissions (4)... done
    Syncing plans (17)... done

As usual, in case you're not inside the app checkout you can specify the app
you want to pull/push to:

    $ heroku mongo:pull --app myapp-staging

If you're inside a checkout with multiple apps deployed, you can also specify
the one to pull/push to by the git remote:

    $ heroku mongo:pull --remote staging


## Notes

Use at your own risk.

Created by Pedro Belo
