{ ... }:
{
  programs.openclaw = {
    documents = "/home/dashu/code/openclaw-local/documents";

    config = {
      gateway = {
        mode = "local";
        auth = {
          token = "5EytUG1OcuogBs2QnRNCx4RCznFUNq7s1zDhIotNxEY";
        };
      };

      env.vars = {
        ANTHROPIC_API_KEY = "/home/dashu/.secrets/anthropic-api-key";
      };

      channels.telegram = {
        tokenFile = "/home/dashu/.secrets/telegram-bot-token";
        allowFrom = [ 123456789 ];
        groups = {
          "*" = {
            requireMention = true;
          };
        };
      };
    };

    instances.default = {
      enable = true;
      plugins = [ ];
    };
  };
}