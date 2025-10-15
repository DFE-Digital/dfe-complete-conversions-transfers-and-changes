# Email System Audit - Executive Summary

## Overview

**Audit Date**: December 2024  
**Scope**: Complete automated email system audit  
**Total Emails Found**: 4 automated emails across 3 mailer classes  
**Status**: ✅ Complete audit with actionable remediation plan

## Key Findings

### Email System Architecture
- **Delivery Method**: GOV.UK Notify via `mail-notify` gem
- **Processing**: Async delivery via Sidekiq in production
- **Templates**: 4 GOV.UK Notify templates with UUID identifiers
- **Recipients**: Team leaders, caseworkers, and new users

### Email Inventory Summary
| Email Type | Template ID | Trigger | Recipients |
|------------|-------------|---------|------------|
| User Account Added | `d55de8f1-ce5a-4498-8229-baac7c0ee45f` | Service support creates user | New user |
| Conversion Project Created | `ea4f72e4-f5bb-4b1a-b5f9-a94cc1840353` | Project assigned to regional team | All team leaders |
| Transfer Project Created | `b0df8e28-ea23-46c5-9a83-82abc6b29193` | Project assigned to regional team | All team leaders |
| Project Assigned | `ec6823ec-0aae-439b-b2f9-c626809b7c61` | Project assigned to caseworker | Assigned caseworker |

## Top 3 Root Causes for Email Failures

### 1. 🚨 **Sidekiq Workers Not Running** (HIGH LIKELIHOOD)
- **Issue**: Production uses async delivery but Sidekiq may be down
- **Impact**: All emails fail silently, no error messages
- **Fix**: Restart Sidekiq workers, check Redis connectivity

### 2. 🔑 **Wrong GOV.UK Notify API Key** (MEDIUM-HIGH LIKELIHOOD)  
- **Issue**: Test/Team key used instead of Live key in production
- **Impact**: Emails appear to send but never delivered
- **Fix**: Verify API key type in GOV.UK Notify dashboard

### 3. 👥 **No Active Team Leaders** (MEDIUM LIKELIHOOD)
- **Issue**: All team leaders deactivated or missing `manage_team` flag
- **Impact**: Team leader emails not sent (silent failure)
- **Fix**: Reactivate users or assign team leadership roles

## Environment Configuration Issues

| Environment | Queue Adapter | API Key Type | Email Delivery |
|-------------|---------------|--------------|----------------|
| **Development** | Default (async/inline) | Team/Guest | Limited recipients only |
| **Test** | `:test` | Test | Not sent (visible in dashboard) |
| **Production** | `:sidekiq` | Live | Actually sent |

## Critical Dependencies

- **Redis**: Required for Sidekiq queue processing
- **GOV.UK Notify API**: Required for all email delivery
- **Active Users**: Required for recipient scopes
- **HOSTNAME**: Required for URL generation in emails

## Immediate Action Items

### Within 1 Hour
1. ✅ Check Sidekiq process: `ps aux | grep sidekiq`
2. ✅ Verify Redis: `redis-cli ping`
3. ✅ Check API key: `echo $GOV_NOTIFY_API_KEY | head -c 10`
4. ✅ Count team leaders: `User.team_leaders.count` in Rails console

### Within 1 Day
1. 🔧 Restart Sidekiq if needed
2. 🔧 Fix API key if wrong type
3. 🔧 Reactivate team leaders if needed
4. 🔧 Test email delivery end-to-end

## Documentation Package

This audit includes 5 comprehensive documents:

1. **[EMAIL_INVENTORY.md](./EMAIL_INVENTORY.md)** - Complete table of all emails with triggers, recipients, and code locations
2. **[FLOWS.md](./FLOWS.md)** - Detailed flow diagrams and sequence charts for each email
3. **[RELIABILITY_CHECKLIST.md](./RELIABILITY_CHECKLIST.md)** - Environment configs, monitoring, and diagnostic commands
4. **[REMEDIATION_PLAN.md](./REMEDIATION_PLAN.md)** - Top 3 root causes with concrete fixes and implementation steps
5. **[EXECUTIVE_SUMMARY.md](./EXECUTIVE_SUMMARY.md)** - This overview document

## Success Metrics

- **Email Delivery Rate**: Target >95% success rate
- **Queue Processing**: <100 jobs in queue
- **Response Time**: <5 seconds for email jobs
- **Error Rate**: <1% failed jobs

## Next Steps

1. **Immediate**: Execute diagnostic steps from Remediation Plan
2. **Short-term**: Implement fixes for identified root causes
3. **Long-term**: Add monitoring and health checks for email system
4. **Ongoing**: Regular audits of email delivery and user feedback

---

**Contact**: Development Team  
**Escalation**: Product Owner  
**Monitoring**: Application Insights dashboards
