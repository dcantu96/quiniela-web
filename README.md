# Quiniela Web

Quiniela Web is a Ruby on Rails application for managing sports pools (quinielas). Users can join groups, make weekly picks for matches, and compete in tournaments. The app supports user authentication, group and tournament management, weekly match tracking, and automated notifications.

## Features

- User registration and authentication (Devise)
- Join or create groups for tournaments
- Weekly match schedules and pick submissions
- Admin dashboard for managing users, groups, matches, and tournaments
- Rich text updates and notifications (ActionText)
- Background jobs for updating results and sending emails (GoodJob)
- Responsive UI with Tailwind CSS

## Getting Started

### Requirements

- Ruby 3.2.2
- Rails ~> 7.0.8
- PostgreSQL

### Setup

```sh
bundle install
bin/yarn
bin/rails db:setup
```

### Running the App

```sh
bin/rails server
```

### Running Tests

```sh
bin/rails test
```

## Services

- Background jobs: GoodJob
- Email delivery: ActionMailer (configured for SMTP)
- Rich text: ActionText

## Deployment

See [config/environments/production.rb](config/environments/production.rb) for production settings.

---

For more details, see the codebase and comments.
