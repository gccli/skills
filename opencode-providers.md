# REFERENCE

https://opencode.ai/docs/providers/

Add the API keys for the provider using the `/connect` command.


**Credentials**: `~/.local/share/opencode/auth.json`

**Config**:  `provider`
```
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
      "anthropic": {
         "options": {
           "baseURL": "https://api.anthropic.com/v1"
          }
      }
  }
}
```
