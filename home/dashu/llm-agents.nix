{ inputs, ... }:
let
  inherit (inputs) llm-agents;
in
{
  home.packages = with llm-agents.packages.x86_64-linux; [
    # AI Coding Agents
    claude-code
    mimo-code
    opencode

    # Claude Code Ecosystem
    cc-switch-cli
    # oh-my-claudecode

    # Skills & Plugins
    claude-plugins
    skills

    # Utilities
    # agent-browser
  ];
}
