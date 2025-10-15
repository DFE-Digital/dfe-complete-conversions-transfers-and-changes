# Email Delivery Remediation Plan

## Executive Summary

Based on the comprehensive email system audit, this document identifies the **top 3 most likely root causes** for users not receiving emails and provides concrete remediation steps with evidence and implementation details.

## Top 3 Root Causes (Ranked by Likelihood)

### 1. 🚨 **Sidekiq Workers Not Running or Redis Connection Issues**

**Likelihood**: **HIGH** - Most common cause of async email failures

**Evidence**:
- Production uses `config.active_job.queue_adapter = :sidekiq` (`config/environments/production.rb:103`)
- All emails use `deliver_later` (async delivery)
- No fallback mechanism if Sidekiq fails
- Jobs enqueued on `"default"` queue but never processed

**Symptoms**:
- Users report not receiving emails
- No error messages in application logs
- Jobs appear in queue but never complete
- Application functions normally otherwise

**Diagnostic Steps**:
```bash
# Check Sidekiq process
ps aux | grep sidekiq

# Check Redis connectivity
redis-cli ping

# Check queue status (if Sidekiq web UI enabled)
curl http://localhost/sidekiq

# Check Rails logs for Sidekiq errors
grep -i sidekiq /var/log/rails/application.log
```

**Immediate Fixes**:
1. **Restart Sidekiq workers**:
   ```bash
   # If using systemd
   sudo systemctl restart sidekiq
   
   # If using Docker
   docker-compose restart sidekiq
   
   # If manual process
   pkill -f sidekiq && bundle exec sidekiq
   ```

2. **Check Redis connection**:
   ```bash
   # Test Redis connectivity
   redis-cli -h $REDIS_HOST -p $REDIS_PORT ping
   
   # Check Redis memory usage
   redis-cli info memory
   ```

3. **Verify environment variables**:
   ```bash
   echo $REDIS_URL
   echo $GOV_NOTIFY_API_KEY
   ```

**Long-term Solutions**:
- Add Sidekiq health check endpoint
- Implement Sidekiq monitoring (e.g., Sidekiq Pro monitoring)
- Add fallback to synchronous delivery for critical emails
- Set up alerts for queue depth and failed jobs

---

### 2. 🔑 **Wrong GOV.UK Notify API Key Type in Production**

**Likelihood**: **MEDIUM-HIGH** - Common configuration error

**Evidence**:
- Development uses Team/Guest key (limited recipients)
- Test uses Test key (emails not sent)
- Production should use Live key but may be misconfigured
- No validation of API key type in code

**Symptoms**:
- Emails appear to send successfully (no errors)
- Recipients never receive emails
- GOV.UK Notify dashboard shows no delivery attempts
- Different behavior between environments

**Diagnostic Steps**:
```bash
# Check API key format
echo $GOV_NOTIFY_API_KEY | head -c 10

# Expected formats:
# Live key: starts with "live-" (73 chars)
# Test key: starts with "test-" (73 chars)  
# Team key: different format (varies)

# Check in Rails console
Rails.application.config.action_mailer.notify_settings
```

**Immediate Fixes**:
1. **Verify API key type**:
   - Log into GOV.UK Notify dashboard
   - Check service settings for API keys
   - Ensure production uses Live API key

2. **Test API key**:
   ```ruby
   # In Rails console
   require 'notifications/client'
   client = Notifications::Client.new(ENV['GOV_NOTIFY_API_KEY'])
   client.get_notification('test') # Should work with valid key
   ```

3. **Update environment variable**:
   ```bash
   # Set correct Live API key
   export GOV_NOTIFY_API_KEY="live-..."
   ```

**Long-term Solutions**:
- Add API key validation on startup
- Implement environment-specific key validation
- Add monitoring for GOV.UK Notify API errors
- Create automated tests for email delivery

---

### 3. 👥 **All Team Leaders Deactivated or Missing**

**Likelihood**: **MEDIUM** - Data state issue

**Evidence**:
- Team leader emails sent to `User.team_leaders` scope (`app/models/user.rb:14`)
- Scope requires `manage_team: true` AND `deactivated_at: nil`
- Guard clause `if team_leader.active` skips inactive users
- No error when no team leaders exist

**Symptoms**:
- Team leader emails not sent
- Project creation/handover works normally
- No error messages
- Silent failure due to empty scope

**Diagnostic Steps**:
```ruby
# In Rails console
User.team_leaders.count
# Should return > 0

User.where(manage_team: true).count
# Check if any users have manage_team flag

User.active.count
# Check if any users are active

User.team_leaders.pluck(:email, :manage_team, :deactivated_at)
# Detailed view of team leader status
```

**Immediate Fixes**:
1. **Check team leader status**:
   ```ruby
   # Find users who should be team leaders
   User.where(manage_team: true).each do |user|
     puts "#{user.email}: active=#{user.active}, deactivated_at=#{user.deactivated_at}"
   end
   ```

2. **Reactivate team leaders**:
   ```ruby
   # Reactivate deactivated team leaders
   User.where(manage_team: true, deactivated_at: Date.yesterday..Date.today).update_all(deactivated_at: nil)
   ```

3. **Assign team leadership**:
   ```ruby
   # If no team leaders exist, assign to appropriate users
   User.where(team: ['regional_casework_services', 'north_west', 'north_east', 'midlands', 'south_west', 'south_east']).limit(2).update_all(manage_team: true)
   ```

**Long-term Solutions**:
- Add validation to ensure at least one team leader exists
- Implement team leader role assignment workflow
- Add monitoring for empty team leader scope
- Create admin interface for user role management

---

## Additional Investigation Areas

### 4. Template Issues in GOV.UK Notify
- **Check**: Template IDs exist and are "Live" status
- **Verify**: Personalization variables match code expectations
- **Test**: Send test email via GOV.UK Notify dashboard

### 5. HOSTNAME Configuration
- **Check**: `ENV["HOSTNAME"]` is set correctly in production
- **Verify**: URLs in emails resolve properly
- **Test**: Click links in test emails

### 6. Conditional Logic Issues
- **Check**: `assigned_to_regional_caseworker_team` flag is set correctly
- **Verify**: Project assignment workflow triggers emails
- **Review**: Guard clauses aren't overly restrictive

## Implementation Priority

### Immediate (Within 1 hour)
1. ✅ Check Sidekiq process status
2. ✅ Verify Redis connectivity  
3. ✅ Check GOV.UK Notify API key type
4. ✅ Count active team leaders

### Short-term (Within 1 day)
1. 🔧 Restart Sidekiq if needed
2. 🔧 Fix API key if wrong type
3. 🔧 Reactivate team leaders if needed
4. 🔧 Add basic monitoring

### Long-term (Within 1 week)
1. 📊 Implement comprehensive monitoring
2. 📊 Add health check endpoints
3. 📊 Create automated tests
4. 📊 Document operational procedures

## Success Metrics

### Immediate Success Indicators
- [ ] Sidekiq workers running and processing jobs
- [ ] Redis connection healthy
- [ ] GOV.UK Notify API key is Live type
- [ ] At least 2 active team leaders exist
- [ ] Test email sent successfully

### Ongoing Monitoring
- [ ] Queue depth < 100 jobs
- [ ] Failed job rate < 1%
- [ ] Email delivery success rate > 95%
- [ ] Response time < 5 seconds for email jobs

## Rollback Plan

If fixes cause issues:
1. **Revert environment variables** to previous values
2. **Restart Sidekiq** with previous configuration
3. **Check application logs** for new errors
4. **Monitor** email delivery for 24 hours
5. **Document** any new issues discovered

## Contact Information

**Primary**: Development Team
**Secondary**: DevOps/Infrastructure Team  
**Escalation**: Product Owner

**Monitoring**: Check Application Insights dashboards for ongoing issues
**Documentation**: All findings documented in this audit package
