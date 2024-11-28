# Authentication and session cookie

## Cookie decryption

See `lib/tasks/session.rake` for a demonstration of how the session
cookie is decrypted with a PBKDF2 secret (AES-256-GCM cipher) which
includes:

- `Rails.application.secret_key_base`:
	 a random string used as an input secret to the app's key generator

- `Rails.configuration.action_dispatch.authenticated_encrypted_cookie_salt`:
 	Rails uses different salts for both encrypted and signed cookies

- `Rails.configuration.active_support.hash_digest_class`:
	a SHA256 digest

By decrypting the logged in user's cookie in this way the .NET
application will be able to obtain the `user_id` needed to look
up the user in the complete `users` table.

To run the rake task and decrypt a cookie which you've pulled out
of your browser's devtools, supply the undecoded cookie like this:

```
bundle exec rake session:decrypt COOKIE="cIgYVwe3C9fVh355Zg%2BDjdK1Tt5mHItWuPYIn%2Fy%2B92nutcXQMBzHwloWRM4hmN0dQVh8E0Q78zIk8giwpIE7ntVL5Ee5oQXsyEnEpDUlZAeCl4ZAkSOSel9o184zyrgri%2BpdCpXT%2FFFmGp8k1GYXE013yVwDeDLZJeBGSQfjUxtCZErdwFOQASbLlnTWpMUys3oZ0UTzY9HBIgynXtKwS1OMBCPze0lWwwyPLNrp4j6BmxXoTX%2F7Bs90pVXyVa43LT9MwHOGY3jnzPt59q4Fpa5BCL2XYGN4FZPqg2wNEDROPxgFDEmX2B6PYO8D%2FcaA%2BfwVIKHZ4uI4bmqoUn7SCLTmXx0Fx0D2gSESwNSGjw%3D%3D--VwPaQ9K%2B2PHbQC%2Bz--XH93ghKMUa0Yn9dGzlGAhg%3D%3D"

->

{
 "session_id"=>"f57e11a6e875533d084626885112f147",
 "_csrf_token"=>"4E1tIKwlCxuAWE0RRPQZwOYtdmWJ635yUs1wQzGoWBs",
 "user_id"=>"C0E6225C-5040-4C6C-A126-CE90C2F8D86E"
 }
```

## Authentication With Azure

If the user is not logged in (no valid user ID present in the session
cookie) we send them to Azure to perform the ["authorisation code" flow](https://learn.microsoft.com/en-us/azure/active-directory-b2c/authorization-code-flow).

On success we receive a response from Azure Identity Provider to:

```
GET "/auth/azure_activedirectory_v2/callback?code={long access token}"
```

The Ruby Omniauth library handles this OAuth2 authentication with the
Azure Identity Provider and provides the access token (set of "claims")
for the logged in user to the Rails "request environment" (`request.env`)
 under the `omniauth.auth` key:

(Note that IDs are not real.)

```json
{
    "provider": "azure_activedirectory_v2",
    "uid": "3c7fb9d5-ac23-4ac0-8e92-d8bac711ffdd",
    "info": {
        "name": "DAVEY, Ed",
        "email": "Ed.DAVEY@education.gov.uk",
        "nickname": "Ed.DAVEY@EDUCATION.GOV.UK",
        "first_name": "Ed",
        "last_name": "DAVEY"
    },
    "credentials": {
        "token": "eyJ0eXAiOiJKV1QiLC...M1ikA",
        "expires_at": 1732632254,
        "expires": true
    },
    "extra": {
        "raw_info": {
            "iat": 1732626995,
            "nbf": 1732626995,
            "exp": 1732632255,
            "email": "Ed.DAVEY@education.gov.uk",
            "groups": [
                "75f97bdc-7773-4015-a6b9-e19f3261d573",
                "b7b04b4e-7df0-49cd-a34a-f686fe208064"
            ],
            "name": "DAVEY, Ed",
            "oid": "3c7fb9d5-ac23-4ac0-8e92-d8bac711ffdd",
            "preferred_username": "Ed.DAVEY@EDUCATION.GOV.UK",
            "app_displayname": "RSD Complete conversions, transfers and changes",
            "family_name": "DAVEY",
            "given_name": "Ed",
            "idtyp": "user",
            "ipaddr": "208.127.46.248",
            "tenant_region_scope": "EU",
            "unique_name": "Ed.DAVEY@EDUCATION.GOV.UK",
            "upn": "Ed.DAVEY@EDUCATION.GOV.UK"
        }
    }
}

```

## Local user cache

From this "auth hash" supplied by the OmniAuth library we persist:

- the user's Active Directory ID
- the user's email address
- the Active Directory Group IDs of the user's groups

The locally persisted `User` representation looks like:

```rb
id: "C0E6225C-5040-4C6C-A126-CE90C2F8D86E",
email: "ed.davey@education.gov.uk",
created_at: Tue, 19 Nov 2024 15:50:14.738902000 GMT +00:00,
updated_at: Tue, 26 Nov 2024 12:19:37.557815000 GMT +00:00,
manage_team: false,
add_new_project: true,
first_name: "Ed",
last_name: "Davey",
active_directory_user_id: "3c7fb9d5-ac23-4ac0-8e92-d8bac711ffdd",
assign_to_project: true,
manage_user_accounts: false,
active_directory_user_group_ids:
    ["75f97bdc-7773-4015-a6b9-e19f3261d573",
     "b7b04b4e-7df0-49cd-a34a-f686fe208064"],
team: "south_west",
deactivated_at: nil,
manage_conversion_urns: false,
manage_local_authorities: false,
latest_session: Tue, 26 Nov 2024 12:19:37.477855000 GMT +00:00>
```

## State management with session cookie

We use an `Authentication` module on all requests (except public
routes) to verify that the user is logged in. That module compares
the `User#id` which the browser presents in its session cookie with
the local `User` table.

```rb

private def current_user
  return unless user_authenticated?

  @current_user ||= User.find(current_user_id)
end

private def user_authenticated?
  current_user_id.present?
end

private def current_user_id
  session[:user_id]
end
```

So, for the above user we require a session cookie which decrypts
to provide a `user_id` of `C0E6225C-5040-4C6C-A126-CE90C2F8D86E`
like:

```rb
{
  "session_id"=>"f57e11a6e875533d084626885112f147",
  "_csrf_token"=>"4E1tIKwlCxuAWE0RRPQZwOYtdmWJ635yUs1wQzGoWBs",
  "user_id"=>"C0E6225C-5040-4C6C-A126-CE90C2F8D86E"
}
```

See `config/application.rb` for config of the cookie session store:

```rb
config.session_store :cookie_store, key: "SESSION"

```
