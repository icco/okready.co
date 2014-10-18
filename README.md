# OK Ready

 * Github: http://github.com/railsrumble/r14-team-232
 * Herokai:
   * http://ancient-ravine-4945.herokuapp.com/
   * http://simple-casual.r14.railsrumble.com
   * http://okready.co
 * [Design Doc](https://docs.google.com/document/d/1tSVuOF6YDk_xui1GdLN5mWBeY4Odkj9MS0nIZMgI_P8/edit)


## Deployment

[![Build Status](https://travis-ci.org/railsrumble/r14-team-232.svg?branch=master)](https://travis-ci.org/railsrumble/r14-team-232)

If you push to github, travis should auto build the repo and push to heroku.

## Local testing

 * `bundle install`
 * `rake db:setup` or `rake db:migrate`
 * `rake local`

You'll need to have a postgres db on localhost called `okready`, or set `DATABASE_URL` to something else.
