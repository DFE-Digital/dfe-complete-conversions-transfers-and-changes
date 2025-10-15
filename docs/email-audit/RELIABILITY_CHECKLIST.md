# Email Reliability Checklist

## Overview

This document provides a comprehensive checklist for diagnosing email delivery issues and ensuring reliable email functionality across all environments.

## Environment Configuration Comparison

| Setting | Development | Test | Production |
|---------|-------------|------|------------|
| **Delivery Method** | `:notify` | `:notify` | `:notify` |
| **Queue Adapter** | Not specified (defaults to async/inline) | `:test` | `:sidekiq` |
| **GOV.UK Notify API Key Type** | Team/Guest | Test | Live |
| **Email Delivery** | Only to whitelisted emails | Not sent (visible in Notify UI) | Actually sent |
| **Default URL Host** | `localhost:3000` | `https://example.com` | `ENV["HOSTNAME"]` |
| **Error Handling** | Full error reports | Full error reports | Logged only |

### Configuration Files

**Development** (`config/environments/development.rb:62-66`):
```ruby
config.action_mailer.default_url_options = {host: "localhost", port: 3000}
config.action_mailer.delivery_method = :notify
config.action_mailer.notify_settings = {
  api_key: ENV["GOV_NOTIFY_API_KEY"]
}
```

**Test** (`config/environments/test.rb:59-60`):
```ruby
config.action_mailer.default_url_options = {host: "https://example.com"}
config.active_job.queue_adapter = :test
```

**Production** (`config/environments/production.rb:95-103`):
```ruby
config.action_mailer.default_url_options = {host: ENV["HOSTNAME"]}
config.action_mailer.delivery_method = :notify
config.action_mailer.notify_settings = {api_key: ENV["GOV_NOTIFY_API_KEY"]}
config.active_job.queue_adapter = :sidekiq
```

## GOV.UK Notify Configuration

### Service Details
- **Service ID**: `32d75f94-b459-4e65-b753-3f9d55c8c9b7`
- **Dashboard**: https://www.notifications.service.gov.uk/services/32d75f94-b459-4e65-b753-3f9d55c8c9b7
- **Gem Used**: `mail-notify` (dxw/mail-notify)

### API Key Types by Environment

| Environment | API Key Type | Behavior |
|-------------|--------------|----------|
| **Development** | Team and Guest | Only sends to team email addresses and guest addresses registered in Notify |
| **Test** | Test | Emails not sent, but visible in Notify dashboard for testing |
| **Production** | Live | Actually sends emails to recipients |

### Template Verification Status

**Required Templates**:
- `d55de8f1-ce5a-4498-8229-baac7c0ee45f` - User account added
- `ea4f72e4-f5bb-4b1a-b5f9-a94cc1840353` - Conversion project created
- `b0df8e28-ea23-46c5-9a83-82abc6b29193` - Transfer project created  
- `ec6823ec-0aae-439b-b2f9-c626809b7c61` - Project assigned notification

**Verification Required**: Check each template exists in GOV.UK Notify dashboard and verify:
- Template content matches expected subject lines
- Personalization variables match code expectations
- Template status is "Live" or "Ready to use"

## Queue Configuration

### Sidekiq Settings (Production)
- **Queue Adapter**: `config.active_job.queue_adapter = :sidekiq`
- **Default Queue**: `"default"`
- **Job Class**: `ActionMailer::MailDeliveryJob`
- **Redis Dependency**: Required for Sidekiq operation

### Queue Monitoring Checklist
- [ ] Sidekiq process running
- [ ] Redis connection healthy
- [ ] No dead jobs in queue
- [ ] No failed jobs exceeding retry limit
- [ ] Queue processing rate normal
- [ ] Memory usage within limits

### Development Queue Behavior
- **No explicit adapter**: Defaults to async or inline delivery
- **Potential issue**: May process jobs synchronously, causing timeouts

## Critical Environment Variables

### Required Variables
- `GOV_NOTIFY_API_KEY` - Required per `config/initializers/dontenv.rb:6`
- `HOSTNAME` - Required for URL generation in production emails
- `REDIS_URL` - Required for Sidekiq in production

### Variable Validation
```bash
# Check required variables are set
echo $GOV_NOTIFY_API_KEY
echo $HOSTNAME
echo $REDIS_URL

# Verify GOV.UK Notify API key format
# Should be 73 characters, starts with "test-" or "live-" or team key format
```

## Logging and Monitoring

### Application Insights (Production)
- **Key**: `ENV["APPLICATION_INSIGHTS_KEY"]`
- **Middleware**: `ApplicationInsights::Rack::TrackRequest`
- **Exception Handling**: `ApplicationInsights::UnhandledException.collect`

### Error Notification
- **Service**: `Ops::ErrorNotification` (`lib/ops/error_notification.rb`)
- **Channel**: Slack notifications for production errors
- **Scope**: Production environment only

### Email-Specific Logging
- **No explicit email logging** found in codebase
- **Rails default**: ActionMailer logs delivery attempts
- **GOV.UK Notify**: Dashboard shows delivery status and failures

## Known Failure Modes

### 1. Configuration Issues

**Missing API Key**:
- **Symptom**: `Dotenv::MissingKeys` error on startup
- **Cause**: `GOV_NOTIFY_API_KEY` not set
- **Fix**: Set environment variable

**Wrong API Key Type**:
- **Symptom**: Emails not delivered in production
- **Cause**: Test API key used instead of Live key
- **Fix**: Verify API key type in GOV.UK Notify dashboard

**Invalid HOSTNAME**:
- **Symptom**: Broken URLs in emails
- **Cause**: `ENV["HOSTNAME"]` not set or incorrect
- **Fix**: Set correct hostname for environment

### 2. Queue Issues

**Sidekiq Not Running**:
- **Symptom**: Jobs enqueued but never processed
- **Cause**: Sidekiq worker process stopped
- **Fix**: Restart Sidekiq workers

**Redis Connection Failure**:
- **Symptom**: Sidekiq errors, jobs not enqueued
- **Cause**: Redis unavailable or connection timeout
- **Fix**: Check Redis service and connection settings

**Queue Backlog**:
- **Symptom**: Delayed email delivery
- **Cause**: More jobs enqueued than processed
- **Fix**: Scale Sidekiq workers or investigate slow jobs

### 3. Data State Issues

**No Team Leaders**:
- **Symptom**: Team leader emails not sent
- **Cause**: `User.team_leaders` scope returns empty
- **Fix**: Check users have `manage_team: true`

**All Users Deactivated**:
- **Symptom**: No emails sent to any users
- **Cause**: All users have `deactivated_at` set
- **Fix**: Reactivate users or check deactivation logic

**Missing Assignable Users**:
- **Symptom**: Assignment emails not sent
- **Cause**: `User.assignable` scope returns empty
- **Fix**: Check users have `assign_to_project: true`

### 4. GOV.UK Notify Issues

**Template Not Found**:
- **Symptom**: `TemplateNotFound` errors
- **Cause**: Template ID doesn't exist or wrong service
- **Fix**: Verify template IDs in dashboard

**Template Not Live**:
- **Symptom**: Emails not sent
- **Cause**: Template status is "Draft" or "Pending"
- **Fix**: Publish template in GOV.UK Notify

**Rate Limiting**:
- **Symptom**: `TooManyRequests` errors
- **Cause**: Exceeding GOV.UK Notify rate limits
- **Fix**: Implement retry with backoff

**Invalid Personalization**:
- **Symptom**: `ValidationError` from GOV.UK Notify
- **Cause**: Missing or invalid personalization variables
- **Fix**: Check personalization data in mailer methods

## Diagnostic Commands

### Check Sidekiq Status
```bash
# Check if Sidekiq is running
ps aux | grep sidekiq

# Check Sidekiq web UI (if enabled)
# Usually available at /sidekiq

# Check Redis connection
redis-cli ping
```

### Check Environment Variables
```bash
# In Rails console
Rails.application.config.action_mailer.delivery_method
Rails.application.config.action_mailer.notify_settings
Rails.application.config.active_job.queue_adapter
```

### Test Email Sending
```ruby
# In Rails console - test mailer directly
user = User.first
UserAccountMailer.new_account_added(user).deliver_now

# Check job enqueueing
ActiveJob::Base.queue_adapter.enqueued_jobs
```

### Check User Scopes
```ruby
# In Rails console
User.team_leaders.count
User.assignable.count
User.active.count
User.where(manage_team: true).count
```

## Monitoring Recommendations

### Production Monitoring
1. **Set up alerts** for Sidekiq queue depth
2. **Monitor Redis** memory usage and connection health
3. **Track GOV.UK Notify** API usage and error rates
4. **Alert on** failed job retry exhaustion
5. **Monitor** email delivery success rates

### Health Checks
1. **Add endpoint** to check Sidekiq connectivity
2. **Add endpoint** to verify GOV.UK Notify API key
3. **Add endpoint** to check critical user scopes
4. **Add endpoint** to verify template existence

### Logging Enhancements
1. **Add structured logging** for email events
2. **Log personalization** data (sanitized)
3. **Log delivery** success/failure with reasons
4. **Add metrics** for email volume by type
