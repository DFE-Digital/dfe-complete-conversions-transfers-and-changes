# Local Azure CDN Setup

This document explains how to set up the required Azure environment variables for local development of the CDN rerouting rules functionality.

## Required Environment Variables

Create a `.env.development.local` file in your project root with the following variables:

```bash
# Azure Authentication
# For local development, you can use either managed identity or client credentials
# Managed Identity (typically used in Azure environments)
IDENTITY_ENDPOINT=
IDENTITY_HEADER=
AZURE_CLIENT_ID=

# Client Credentials (recommended for local development)
AZURE_TENANT_ID=your-tenant-id
AZURE_APPLICATION_CLIENT_ID=your-app-client-id
AZURE_APPLICATION_CLIENT_SECRET=your-app-client-secret

# Azure CDN Configuration
AZURE_SUBSCRIPTION_ID=your-subscription-id
AZURE_FRONT_DOOR_RESOURCE_GROUP_NAME=your-resource-group-name
AZURE_FRONT_DOOR_PROFILE_NAME=your-cdn-profile-name
AZURE_FRONT_DOOR_RULE_SET_NAME=your-rule-set-name

# Other required variables
GOV_NOTIFY_API_KEY=your-gov-notify-api-key
AZURE_REDIRECT_URI=http://localhost:3000/auth/azure_activedirectory_v2/callback
```

## Setting Up Azure Service Principal

To get the required Azure credentials:

1. **Create a Service Principal:**
   ```bash
   az ad sp create-for-rbac --name "dfe-complete-conversions-local-dev" --role "Reader" --scopes "/subscriptions/{subscription-id}"
   ```

2. **Assign CDN Reader Role:**
   ```bash
   az role assignment create --assignee {app-id} --role "CDN Profile Reader" --scope "/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}/providers/Microsoft.Cdn/profiles/{profile-name}"
   ```

3. **Assign CDN Rules Reader Role:**
   ```bash
   az role assignment create --assignee {app-id} --role "CDN Endpoint Reader" --scope "/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}/providers/Microsoft.Cdn/profiles/{profile-name}/ruleSets/{rule-set-name}"
   ```

## Alternative: Use Azure CLI Authentication

If you have Azure CLI installed and are logged in, you can modify the client to use Azure CLI authentication instead of service principal authentication.

## Development Fallback

If you don't want to set up Azure authentication for local development, the application will automatically fall back to using sample patterns when running in development mode. This is handled in the `DotnetReroutingRulesService` class.

## Testing the Setup

To test if your Azure setup is working:

1. Set up the environment variables
2. Start your Rails application
3. Check the logs for any authentication errors
4. The service should either return real Azure CDN rules or fall back to development patterns

## Troubleshooting

- **"No patterns found"** - This usually means insufficient Azure permissions
- **"Authentication failed"** - Check your service principal credentials
- **"Token expired"** - The client will automatically refresh tokens
- **"Resource not found"** - Verify your Azure resource names and subscription ID
