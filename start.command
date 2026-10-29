#!/bin/bash
# Double-click this file to start the site on a Mac (or run it on Linux).
cd "$(dirname "$0")"

# For the real chatbot, remove the # below and paste your Claude API key (console.anthropic.com).
# export ANTHROPIC_API_KEY=your-key
# Or use Google Gemini instead: remove the # below and paste a key from aistudio.google.com.
# export GOOGLE_API_KEY=your-key

# Optional: for the studio male voice, remove the # below and paste your Azure Speech key.
# export AZURE_SPEECH_KEY=your-key
# export AZURE_SPEECH_REGION=westeurope

if ! command -v node >/dev/null; then
  echo "Node.js is not installed. Get it from https://nodejs.org and run this file again."
  read -r -p "Press Enter to close."
  exit 1
fi

echo "Starting the library. Keep this window open; close it to stop the server."
(sleep 2; open http://localhost:3000 2>/dev/null || xdg-open http://localhost:3000 2>/dev/null) &
node server.js
