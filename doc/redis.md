# Redis

The application depends on Redis:

- for the Sidekiq queue
- to store temporary values in stepped (multi step) forms

Redis is required in all environments.

Redis config is in `config/application.rb` and the Redis server URL is stored in
the `REDIS_URL` environment variable.
