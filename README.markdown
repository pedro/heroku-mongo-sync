# Heroku - Mongo Sync

This is a plugin for the Heroku command line, adding commands to sync your
local and production mongo databases.

## Installation

    $ heroku plugins:install http://github.com/pedro/heroku-mongo-sync.git

## Config

The plugin assumes your local mongo db is on the URL specified by MONGO_URL.
Set it using the url format, like:

    export MONGO_URL = mongo://user:pass@localhost:27017/db

If not present, it will attempt to connect to localhost:27017, without auth,
using the db named after the current Heroku app name.

For production, it fetches the MONGO_URL from the Heroku app config vars.

## Usage

Get a copy of your production database with:

    $ heroku mongo:pull
    Replacing the database at localhost with genesis.mongohq.com
    Syncing users... done
    Syncing permissions... done
    Syncing plans... done

Update your production database with:

    $ heroku mongo:push
    THIS WILL REPLACE ALL DATA ON genesis.mongohq.com WITH localhost
    Are you sure? (y/n) y
    Syncing users... done
    Syncing permissions... done
    Syncing plans... done

## Notes

Use at your risk.

Created by Pedro Belo
