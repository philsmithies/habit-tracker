# Habit Tracker

A self-hosted habit tracker built with Rails 8.1, Hotwire, Tailwind CSS, and SQLite.

## Local setup

```sh
bin/setup
bin/dev
```

Open <http://localhost:3000>, create an account, and add a habit.

## Test

```sh
bin/rails test
bin/rubocop
bin/brakeman --no-pager
```

## Coolify

Deploy this repository as a Dockerfile application. Add a persistent volume with
destination `/rails/storage`; all production SQLite databases and local uploads
live there. Keep the application at one replica because SQLite is a single-host
database.

Set `RAILS_MASTER_KEY` from `config/master.key` as a secret environment variable.
Use `/up` as the health-check path.
# habit-tracker
