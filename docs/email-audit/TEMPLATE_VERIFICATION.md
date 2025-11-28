# GOV.UK Notify Template Verification

## Overview

This document provides the template verification findings and instructions for validating GOV.UK Notify templates against the codebase.

## Template Verification Status

**Service Dashboard**: https://www.notifications.service.gov.uk/services/32d75f94-b459-4e65-b753-3f9d55c8c9b7

**Verification Required**: Manual verification needed for each template ID

## Template Inventory

### 1. User Account Added Email
- **Template ID**: `d55de8f1-ce5a-4498-8229-baac7c0ee45f`
- **Mailer**: `UserAccountMailer#new_account_added`
- **Code Location**: `app/mailers/user_account_mailer.rb:2-10`
- **Personalization Variables**:
  - `first_name` (String) - User's first name
- **Expected Subject**: *To be verified in dashboard*
- **Status**: ⏳ **PENDING VERIFICATION**

### 2. Conversion Project Created Email
- **Template ID**: `ea4f72e4-f5bb-4b1a-b5f9-a94cc1840353`
- **Mailer**: `TeamLeaderMailer#new_conversion_project_created`
- **Code Location**: `app/mailers/team_leader_mailer.rb:2-11`
- **Personalization Variables**:
  - `first_name` (String) - Team leader's first name
  - `project_url` (String) - URL to the project
- **Expected Subject**: *"You have a new project to assign"* (from screenshot)
- **Status**: ⏳ **PENDING VERIFICATION**

### 3. Transfer Project Created Email
- **Template ID**: `b0df8e28-ea23-46c5-9a83-82abc6b29193`
- **Mailer**: `TeamLeaderMailer#new_transfer_project_created`
- **Code Location**: `app/mailers/team_leader_mailer.rb:13-22`
- **Personalization Variables**:
  - `first_name` (String) - Team leader's first name
  - `project_url` (String) - URL to the project
- **Expected Subject**: *To be verified in dashboard*
- **Status**: ⏳ **PENDING VERIFICATION**

### 4. Project Assigned Notification Email
- **Template ID**: `ec6823ec-0aae-439b-b2f9-c626809b7c61`
- **Mailer**: `AssignedToMailer#assigned_notification`
- **Code Location**: `app/mailers/assigned_to_mailer.rb:2-11`
- **Personalization Variables**:
  - `first_name` (String) - Caseworker's first name
  - `project_url` (String) - URL to the project
- **Expected Subject**: *To be verified in dashboard*
- **Status**: ⏳ **PENDING VERIFICATION**

## Manual Verification Instructions

### Step 1: Access GOV.UK Notify Dashboard
1. Navigate to: https://www.notifications.service.gov.uk/services/32d75f94-b459-4e65-b753-3f9d55c8c9b7
2. Log in with appropriate credentials
3. Ensure you have access to the service

### Step 2: Verify Each Template

For each template ID above:

1. **Search for Template**:
   - Use the template ID to search in the dashboard
   - Verify the template exists

2. **Check Template Status**:
   - Status should be "Live" or "Ready to use"
   - If "Draft" or "Pending", template needs to be published

3. **Verify Template Content**:
   - Check subject line matches expectations
   - Verify personalization variables match code expectations
   - Ensure content is appropriate and up-to-date

4. **Test Template**:
   - Use "Send test message" feature
   - Send to a test email address
   - Verify personalization works correctly

### Step 3: Document Findings

For each template, document:

- ✅ **Template exists**: Yes/No
- ✅ **Status**: Live/Draft/Pending
- ✅ **Subject line**: [Actual subject from dashboard]
- ✅ **Personalization variables**: Match code expectations
- ✅ **Content quality**: Appropriate and current
- ✅ **Test delivery**: Successful/Failed

## Expected Verification Results

### Template Content Expectations

**Conversion Project Created** (from screenshot):
- Subject: "You have a new project to assign"
- Content should include:
  - Greeting with `((first_name))`
  - Message about new conversion project
  - Link to project: `((project_url))`
  - Instructions for assignment
  - Help and support information

**Other Templates**:
- Should follow similar GOV.UK design patterns
- Include appropriate personalization
- Have clear, actionable content

## Common Issues Found

### Template Not Found
- **Cause**: Template ID doesn't exist or wrong service
- **Fix**: Create template or verify service access

### Template Not Live
- **Cause**: Template is in Draft status
- **Fix**: Publish template in dashboard

### Missing Personalization
- **Cause**: Template doesn't include required variables
- **Fix**: Update template content to include variables

### Wrong Personalization Format
- **Cause**: Template uses different variable names
- **Fix**: Update either template or code to match

## Verification Checklist

- [ ] All 4 template IDs exist in dashboard
- [ ] All templates have "Live" status
- [ ] Subject lines are appropriate
- [ ] Personalization variables match code expectations
- [ ] Template content is current and accurate
- [ ] Test emails can be sent successfully
- [ ] Personalization renders correctly in test emails

## Post-Verification Actions

### If All Templates Verified Successfully
- Update this document with ✅ status
- Proceed with remediation plan implementation
- Monitor email delivery for 24-48 hours

### If Issues Found
- Document specific issues in this file
- Update remediation plan with template-specific fixes
- Coordinate with GOV.UK Notify team if needed
- Implement fixes before proceeding

## Template Management Recommendations

### Long-term Improvements
1. **Version Control**: Track template changes
2. **Testing**: Regular template testing
3. **Documentation**: Keep template documentation current
4. **Monitoring**: Track template usage and errors
5. **Backup**: Maintain template backups

### Operational Procedures
1. **Change Management**: Require approval for template changes
2. **Testing**: Test all template changes before going live
3. **Rollback**: Maintain ability to rollback template changes
4. **Communication**: Notify users of template changes

---

**Next Steps**: Complete manual verification using instructions above, then update this document with findings.
