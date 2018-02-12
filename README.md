<p align="center"><img alt="Monolith icon" src="https://i.imgur.com/J9seIVR.png"></a>
<h1 align="center">Monolith</h1>
<p align="center"><i>The home of Hack Club's code. Illustrated above.</i></p>
<p align="center">
  <a href="https://circleci.com/gh/hackclub/monolith">
    <img alt="CircleCI" src="https://img.shields.io/circleci/project/github/hackclub/monolith.svg">
  </a>
  <a href="https://codeclimate.com/github/hackclub/monolith">
    <img alt="CodeClimate" src="https://img.shields.io/codeclimate/maintainability/hackclub/monolith.svg">
  </a>
  <a href="https://codeclimate.com/github/hackclub/monolith">
    <img alt="Test Coverage" src="https://img.shields.io/codeclimate/c/hackclub/monolith.svg">
  </a>
</p>

<p align="center">
Monolith currently includes our backend API hosted at https://api.hackclub.com and our legacy frontend codebase, which includes our <a href="https://hackclub.com/workshops">workshops page</a>. Our new frontend codebase is at <code><a href="https://github.com/hackclub/site">hackclub/site</a></code>.
</p>

## How to run it

Go through the [web setup](#web-setup) and [api setup](#api-setup). Once you've got that done you can spin up both at the same time with this command:

```sh
docker-compose up
```

And then `api` and `web` should be live on `localhost:3000` and `localhost:3001` respectively!

## Web Setup

Create a file called `web/.env` with the following contents, replacing "REPLACEME" with actual values:

```sh
# For server-rendered meta tags
REACT_APP_META_TITLE="Start your own Hack Club!"
REACT_APP_META_DESCRIPTION="Learn in your own environment, your own way. Join a network of club leaders around the world who can help you every step of the way."
# In production this is set to "https://hackclub.com/meta_og_image.png"
REACT_APP_META_OG_IMAGE="localhost:3001/meta_og_image.png"

# For Segment analytics
REACT_APP_SEGMENT_KEY=REPLACEME

# For requests to the API used in workshops, slack invites, etc.
# In production this is set to "https://api.hackclub.com"
REACT_APP_API_BASE_URL=localhost:3000

# For Hackbot new team auth
REACT_APP_SLACK_CLIENT_ID=REPLACEME

# For error tracking
REACT_APP_SENTRY_DSN=REPLACEME

# For Stripe donations
REACT_APP_STRIPE_PUBLISHABLE_KEY=REPLACEME
```

All these values are mandatory.

Right now we only maintain web running on docker. While just spinning up the server with node on your own machine should work, milage may vary.

```sh
docker-compose build web
docker-compose run web yarn
```

```sh
# Now you can start up web anytime you want
docker-compose up web
```

## API Setup

### Environmental Variables

Create a file called `api/.env`. The following configuration options are available to set in it:

```
# Number of Rails threads to run per server instance. One database connection is
# made per thread (ex. if this is set to 5, then the database connection pool
# will hold 5 connections).
RAILS_MAX_THREADS

# Port to listen for HTTP requests on
PORT

# Environment to run Rails in (can be "development", "test", or "production")
RAILS_ENV

# URL of Postgres instance to connect to. Rails will automatically connect to
# Docker Compose's instance of Postgres if this isn't set.
DATABASE_URL

# API key for Google Maps geocoding API.
#
# You must also enable the timezone API in your Google Cloud account.
#
# Get a key from https://console.developers.google.com/flows/enableapi?apiid=geocoding_backend&keyType=SERVER_SIDE
GOOGLE_MAPS_API_KEY

# API key for Streak API. Must be an admin's key.
STREAK_API_KEY

# Keys for application, club, leader, letter, and fundraising pipelines in Streak
STREAK_CLUB_APPLICATIONS_PIPELINE_KEY
STREAK_CLUB_PIPELINE_KEY
STREAK_FUNDRAISING_PIPELINE_KEY
STREAK_LEADER_PIPELINE_KEY
STREAK_LETTER_PIPELINE_KEY

# DSN for Sentry (https://sentry.io) (only needed for production)
SENTRY_DSN

# Name of team to put members of Hack Club into on Cloud9 & credentials for
# an account with access to that team.
CLOUD9_TEAM_NAME
CLOUD9_USERNAME
CLOUD9_PASSWORD

# Keys for school and teacher outreach pipelines
STREAK_OUTREACH_SCHOOL_PIPELINE_KEY
STREAK_OUTREACH_TEACHER_PIPELINE_KEY

# For Slack authentication
SLACK_CLIENT_ID
SLACK_CLIENT_SECRET

# For Slack invitation authentication (https://api.slack.com/custom-integrations/legacy-tokens) (make sure this is an admin's legacy-token)
SLACK_ADMIN_ACCESS_TOKEN

# For Slack stats authentication
SLACK_ADMIN_EMAIL
SLACK_ADMIN_PASSWORD

# Default Slack team ID (probably going to be T0266FRGM, which is Hack Club's
# team)
DEFAULT_SLACK_TEAM_ID

# Secret code required when redeeming .tech domains
TECH_DOMAIN_REDEMPTION_SECRET_CODE

# The email of who to assign Streak tasks to
DEFAULT_STREAK_TASK_ASSIGNEE

# Slack channel to mirror Hackbot interactions to
HACKBOT_MIRROR_CHANNEL_ID

# Comma separated list of Slack user IDs that Hackbot should recognize as
# admins. User IDs can be from multiple Slack teams.
HACKBOT_ADMINS

# Streak box to use for demo check-ins
STREAK_DEMO_USER_BOX_KEY

# The API key for our giffing engine. Can be requested from http://docs.guggy.com/,
# otherwise stealing the one from production will probably be find.
GUGGY_API_KEY

# Access token with all scopes enabled for the GitHub account to use as a bot.
GITHUB_BOT_ACCESS_TOKEN

# Credentials to a Stripe account
STRIPE_PUBLISHABLE_KEY
STRIPE_SECRET_KEY

# A list of channel IDs (comma separated) of channels which should have all new messages deleted from them.
CHANNELS_TO_CLEAR

# Segment analytics
SEGMENT_WRITE_KEY

# SMTP settings for sending emails like application confirmations
SMTP_ADDRESS
SMTP_PORT
SMTP_USERNAME
SMTP_PASSWORD
SMTP_DOMAIN

# Auth Token used when receiving a POST request to create an Athul club
ATHUL_AUTH_TOKEN

# HTTP auth to access Sidekiq's web interface
SIDEKIQ_HTTP_USERNAME
SIDEKIQ_HTTP_PASSWORD
```

### Build the container

```sh
git submodule init
git submodule update
docker-compose build api
docker-compose run api bundle
docker-compose run api rails db:create db:setup
```

### Setting up the Slack App

1. Create a new Slack app on Slack
2. Create one (and only one) bot user and set "Always Show My Bot as Online" to "On"
3. Click "Event Subscriptions" on the sidebar in the left and set the request URL to `HOSTNAME/v1/hackbot/webhooks/events`, replacing `HOSTNAME` with your actual hostname.
4. Subscribe to the following bot events: `message.channels`, `message.im`, `message.groups`, `message.mpim`
5. Click "Interactive Messages" on the left sidebar and set the request URL to `HOSTNAME/v1/hackbot/webhooks/interactive_messages`, replacing `HOSTNAME` with your actual hostname.

### Scheduled Jobs

This application depends on a few jobs running periodically in the background. Set this up using cron or a similar scheduler on your deployment of the application -- we use Heroku's scheduler in production.

- `rails heroku_scheduler:queue_update_hackbot_slack_username_job` hourly
- `rails heroku_scheduler:queue_record_slack_stats_job` daily
- `rails heroku_scheduler:queue_activate_clubs_job` daily
- `rails heroku_scheduler:queue_collect_projects_shipped_job` daily
- `rails heroku_scheduler:queue_schedule_leader_check_ins_job` daily
- `rails heroku_scheduler:queue_handle_spam_club_applications_job` every 10 minutes
- `rails heroku_scheduler:queue_update_from_streak_job` hourly
- `rails heroku_scheduler:queue_close_check_ins_job` daily

### Deployment on Heroku

We use Heroku for managing our deployment of this project and that brings along some special caveats. Specifically, we rely on multiple buildpacks.

Here are the buildpacks that need to be configured (they must be in the given order):

```
https://github.com/heroku/heroku-buildpack-apt
heroku/ruby
```

Refer to https://devcenter.heroku.com/articles/buildpacks for instructions on configuring buildpacks.

#### Profiling

We use [Skylight](https://www.skylight.io) to profile the performance of our backend in production. To use it, you must set `SKYLIGHT_AUTHENTICATION` in the environment to the value that Skylight gives you.
