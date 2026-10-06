# Interactive library of historical figures

A bilingual (Bulgarian / English) educational site where a historical figure
answers visitors' questions out loud in a male voice, takes them to the
matching section of the site, and highlights the paragraph that backs up the
answer.

Figures: **Aleko Konstantinov**, **Hristo Botev**, **Vasil Levski**,
**Ivan Vazov**.

## Files

| File | What it is |
|---|---|
| `index.html` | The whole site: every figure and section, both languages, the guide panel, dark mode. |
| `server.js` | Optional small backend: serves the page and provides a studio male voice. |
| `aleko.json`, `botev.json`, `levski.json`, `vazov.json` | Who each figure is for the chatbot: tone, what they can know, voice speed and pitch. |
| `start.bat`, `start.command` | Double-click launchers for Windows and Mac: start the server and open the site. |
| `.env` | Your API keys. Private; never share it. |
| `README.md` | This file. |

Only `index.html` is needed to use the site.

## Run it

**One click:** double-click `start.bat` on Windows or `start.command` on a
Mac. It starts the server and opens the site at http://localhost:3000. Keep
the window that appears open; closing it stops the server. Node.js must be
installed (https://nodejs.org). On a Mac the first time, you may need to
right-click the file and choose Open, or run `chmod +x start.command` once.
To use the studio voice, open the start file in a text editor and paste your
speech key where it says.

**Quickest:** open `index.html` in a browser. Everything works except the
studio voice and real conversation (see "Not built yet").

**With the server** (Node 18 or newer, no packages to install):

```
AZURE_SPEECH_KEY=your-key AZURE_SPEECH_REGION=westeurope node server.js
```

Then open http://localhost:3000. Without a key the server still serves the
page and the browser voice is used.

## Layout

The site works like a small browser with the guide beside it, and the visitor
never leaves the page.

- **Tabs:** one per figure.
- **Toolbar:** back, forward, home, and an address bar such as
  `library://botev/poetry`. Typing an address opens it; typing anything else
  asks the figure.
- **Bookmarks bar:** the sections of the current figure.
- **Guide:** stays on screen the whole time. When it answers, it opens the
  right page in the browser pane for the visitor.

On a phone the browser is on top and the guide is docked underneath.

## How an answer works

1. The visitor asks a question in the guide panel (or the address bar).
2. The browser pane opens a real web page: first the figure's own Wikipedia
   article in the visitor's language, and if the answer is not there, the best
   result of a Wikipedia search.
3. Every place the question's key words appear is marked, as in a browser's
   find-in-page, and the page scrolls to the passage that matches best.
4. A find bar shows the count ("1 / 7"). F3 and Shift+F3 (or the arrows) step
   through the matches, Ctrl+F searches the open page for anything, Esc closes.
5. The figure replies out loud, and the chat keeps a short quote from the page
   with a link back to it.

**Where it looks.** A question put to a figure is treated as a question
about that figure, so the figure's own article is always read first and is the
default answer. Another article is consulted only for words the own article
never uses (a ship, a place, another person), and only if that article also
mentions the figure. Unrelated people who merely share a word with the
question are never shown.

**Finding the right passage.** A passage scores higher the more different
words of the question it contains, and rare words count for more than common
ones. A section whose heading matches the question offers its first paragraph.
Questions in Latin-letter Bulgarian are matched against the Cyrillic text by
trying the likely spellings of each word (j as ж or й, a as а or ъ, 4 as ч,
6 as ш, and so on). The find bar does the same when nothing matches as typed.

**It is a working browser.** Links inside a page open in the pane, back and
forward work, and a web address typed in the address bar opens that site.

- Reload (⟳) fetches the page again, and ↗ opens the original site in a new
  browser tab, which helps for sites that need scripts.
- Going back returns to where you had scrolled on the earlier page.
- Wikipedia pages are read straight from Wikipedia and need no server.
- Any other site needs `server.js` running (use the start file), because a
  browser will not let one site read another.
- Pages are shown with their scripts removed, for safety. Plain article sites
  work well; sites built entirely with scripts show little or nothing.
- With no internet, the guide falls back to the built-in library pages and
  highlights the matching paragraph there.

The built-in pages remain as each figure's home page (the home button).

## The chatbot

With an API key the figures answer in their own words, like a normal chatbot,
and stay in character. Two providers are supported; use whichever key you have.

| Provider | Where to get a key | Line in the start file | Default model |
|---|---|---|---|
| Claude (Anthropic) 
| Gemini (Google) 

1. Open the file named `.env` in a text editor (Notepad is fine).
2. Paste your key after the `=` on the matching line, with no spaces or
   quotes, for example `GOOGLE_API_KEY=abc123`. Save.
3. Start the site with `start.bat` or `start.command`. The window says which
   chatbot is in use.

Keep `.env` private and do not share it or upload it anywhere. If you cannot
see the file, turn on "show hidden files" (Mac: Cmd+Shift+. in Finder).

If both keys are set, Claude is used unless you add `CHAT_PROVIDER=google`.
To pick another model set `CLAUDE_MODEL` or `GEMINI_MODEL`. Both providers get
the same persona file, the same passages and the same rules.

How it works: before answering, the page collects passages from the web (the
figure's Wikipedia article, and other articles when needed) and sends them
with the question to `server.js`. The model answers as the figure, using those
passages for facts, and names the passage it relied on. The page then opens
that web page and highlights the passage.

- The key stays in `server.js` on your computer; the page never sees it.
- Each question is an API call that your provider bills or counts against
  its free allowance; check the provider's current pricing.
- The server allows 30 questions a minute.
- Bulgarian typed in Latin letters is understood ("koga si roden",
  "kakvo stana na parahoda"); the figure answers in Cyrillic.

### The persona files

Each figure follows its own `<figure>.json`, and nothing about a figure is
written into the server code. The whole file is handed to the chatbot as
binding instructions, and it wins over web passages when they disagree.

| Field | What it controls |
|---|---|
| `knowledge_horizon` | The last moment the figure can know about. |
| `reply_sentences` | How long replies are, e.g. `"2-4"`. |
| `rules` | A list of things the figure must always do or never do. |
| `bg` / `en` → `tone` | How the figure speaks in that language. |
| `bg` / `en` → `after_horizon_rule` | How it treats anything after its time. |
| `bg` / `en` → `fact_sheet` | Facts it trusts first (optional). |
| `voice` | Speed and pitch of the studio voice. |

Any other field you add is passed on too. The file is re-read for every
question, so save it and ask again; no restart is needed.
- Without a key, or without the server, the figure falls back to a prepared
  line and still shows the passage.

## Voice

Every figure speaks with a male voice. The text is always Bulgarian (or
English); only the voice that reads it changes.

**Browser voice (default, no setup).** For Bulgarian the page tries, in order:

1. A male Bulgarian voice on the device. Microsoft Edge has one (Borislav).
2. A male Russian voice reading the Bulgarian text: Pavel on Windows, Dmitry
   in Edge, Yuri on Mac and iPhone. Before speaking, the page rewrites the
   letters Russian reads differently (щ becomes шт, ъ becomes а), so the words
   stay Bulgarian. It will still have a Russian accent and some wrong stress.
3. Whatever Bulgarian voice exists, with the pitch pulled right down.

Chrome on its own offers only female Google voices for both languages, so on
a device with no installed male voice step 3 is what you get.

**Studio voice (with `server.js` and a key).** Azure's `bg-BG-BorislavNeural`
for Bulgarian and `en-GB-RyanNeural` for English. This is the only way to get
a true male Bulgarian voice on every device. A figure can get its own speed
and pitch from a `voice` block in `<id>.json`.

## Backend contract

The page calls two endpoints and falls back gracefully if either is missing.

`POST /api/chat`

```
request:  { figure, lang, route, messages: [{ role, content }],
            passages: [{ url, title, text }] }
response: { text, navigate_to, evidence: { p, quote } }
```

- `navigate_to`: a route from the figure's list, or `null`.
- `evidence.p`: number of the paragraph (from 1) in that section to highlight.
- `evidence.quote`: optional exact phrase inside that paragraph to mark.
- `open`: optional `{ url, find }`. Opens that web page in the pane and marks
  the words in `find`. When present it is used in place of `navigate_to`.

`GET /api/page?url=...` returns `{ url, html }` for the browser pane. It only
fetches public web addresses, never this computer or the local network. It is
meant for local use; do not put it on the open internet as it is.

`POST /api/tts`

```
request:  { figure, lang, text }
response: audio/mpeg
```

Keep API keys on the server; the page never sees them.

## Add a figure

1. In `index.html`, add a strings object shaped like `LEVSKI` or `VAZOV`
   (pages, facts and demo replies in both languages).
2. Add one entry to `FIGURES` with its Wikipedia title, years, monogram,
   routes and sources.

3. Add `<id>.json` beside `server.js`, shaped like `levski.json`, so the
   chatbot knows who is speaking.

Nothing else changes: the page logic and the server are shared by all figures.

## Sources and accuracy

- Aleko Konstantinov: the Bulgarian and English Wikipedia articles.
- Hristo Botev, Vasil Levski, Ivan Vazov: the English Wikipedia articles only.
- Text is rewritten, not copied; Wikipedia is licensed CC BY-SA.
- The books listed in the Sources box for Aleko and Botev are the ones those
  articles cite. They were not consulted directly.
- Wikipedia flags its own Bay Ganyo section as possibly unsourced.
- Vazov's publication years follow the English article and are worth
  checking against a Bulgarian reference, "Under the Yoke" (1888) especially.

Have a historian or literature teacher check the text before it is used in
a classroom.


