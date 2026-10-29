# Говорещи портрети / Talking Portraits

A bilingual (Bulgarian / English) educational site shaped like a small
library. Take a figure's book from the shelf, a skeleton's hand opens it, and
the figure answers your questions out loud in a male voice. Every answer gets
its own page in the book, with a picture and the source passage that proves
it highlighted.

Made by **The Goat Soft**.

Figures: **Aleko Konstantinov**, **Hristo Botev**, **Vasil Levski**,
**Ivan Vazov**.

## Files

| File | What it is |
|---|---|
| `index.html` | The whole site in one file: the library, the book opening, the pages, the conversation, both languages, dark mode. |
| `server.js` | Optional small backend: the chatbot, a studio male voice, and pages from other sites. |
| `aleko.json`, `botev.json`, `levski.json`, `vazov.json` | Who each figure is for the chatbot: tone, what they can know, voice speed and pitch. |
| `start.bat`, `start.command` | Double-click launchers for Windows and Mac: start the server and open the site. |
| `.env.example` | Template for your API keys: copy it to `.env`. `.env` is private and ignored by git. |
| `.gitignore` | Keeps `.env` out of the repository. |
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

**Home page: the library.** A shelf of cloth-bound books, one per figure,
with a few unmarked volumes for figures still to come. Below the shelf is the
chronicle: the four lives on one time axis, and the moments their paths cross
(Levski and Botev sharing the mill near Bucharest, for example).

**Opening a book.** Clicking a book takes it from the shelf and lands it on a
candlelit desk; a 3D skeleton's hand (WebGL) reaches in, grips the cover and
opens it, the pages riffle, and the open book glides into place as the book
you read, with the conversation beside it on the right. With "reduce motion" set on the device,
the book opens at once.

**Inside a book** everything is set as real pages, two facing pages at a
time (one on a phone), with running heads, page numbers and a page turn you
can see:

- **The book (left):** the figure's chapters, the web articles that back up
  answers, and a new page for every answer. Turn pages with ‹ ›, the arrow
  keys, Page Up / Page Down, the mouse wheel or a swipe. Moving to another
  chapter or article turns the page too.
- **The conversation (right):** the figure's portrait, the chat, suggested
  questions and the microphone (Chrome and Edge; the browser sends the
  audio to its own speech service to recognise it).
- **Toolbar:** back, Library (returns to the shelf), ⟳ (clears every
  highlight), ↗ (the original web page, when an article is open), light or
  dark, and the language. The chapters run along the top.

**On a phone** one page fills the screen and the conversation is a sheet at
the bottom showing the last reply, the suggested questions and the input.
Swipe it up (or tap it) to see the whole conversation, swipe down to read.

## How an answer works

1. The visitor asks a question in the conversation.
2. The figure's own Wikipedia article is read first; other articles only for
   words it never uses, and only if they mention the figure.
3. The figure replies out loud, and the book turns to **a new page written
   for that answer**, set like a page of an illustrated history:
   - the question as a heading and the figure's reply as an epigraph;
   - the facts under their own heading, with a picture from the source set
     as a plate with its caption (the picture nearest the passage in the
     article, else the article's main picture, else the portrait);
   - the passage that proves the answer, highlighted, with the question's
     words marked (F3 / Shift+F3 step through them, Ctrl+F searches);
   - a footnote naming the source, with a link that sets the whole article
     in the book at the highlighted passage.
4. With the chatbot on, the facts on that page are a short text the chatbot
   writes from the source for the book (third person, only facts from the
   passages), followed by the passage itself under "From the source".
   Without the chatbot, the passage and the paragraphs on either side of it
   are the text of the page.
5. The chat keeps a link back to each answer's page.

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

**Web articles inside the book.** Articles are cleaned (no scripts, frames,
forms, styles or event handlers) and set as book pages in the book's type:
the infobox picture becomes the frontispiece, pictures become plates, and
navigation boxes and reference lists are left out. Links inside an article
open in the book, and back works.

- ↗ opens the original site in a new
  browser tab, which helps for sites that need scripts.
- Going back returns to where you had scrolled on the earlier page.
- Wikipedia pages are read straight from Wikipedia and need no server.
- Any other site needs `server.js` running (use the start file), because a
  browser will not let one site read another.
- Pages are shown with their scripts removed, for safety. Plain article sites
  work well; sites built entirely with scripts show little or nothing.
- With no internet, the figure falls back to the built-in chapters and
  highlights the matching paragraph there.

Each book's built-in chapters stay one click away along the top of the book.

## The chatbot

With an API key the figures answer in their own words, like a normal chatbot,
and stay in character. Two providers are supported; use whichever key you have.

| Provider | Where to get a key | Line in the start file | Default model |
|---|---|---|---|
| Claude (Anthropic) | https://console.anthropic.com | `ANTHROPIC_API_KEY` | `claude-haiku-4-5-20251001` |
| Gemini (Google) | https://aistudio.google.com | `GOOGLE_API_KEY` | `gemini-3.5-flash-lite` |

1. Copy `.env.example` to a new file named `.env` beside it, and open it in a
   text editor (Notepad is fine).
2. Paste your key after the `=` on the matching line, with no spaces or
   quotes, for example `GOOGLE_API_KEY=abc123`. Save.
3. Start the site with `start.bat` or `start.command`. The window says which
   chatbot is in use.

Keep `.env` private: never commit it or upload it anywhere (it is listed in
`.gitignore`). If you cannot
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
response: { text, navigate_to, evidence: { p, quote }, open, page }
```

- `navigate_to`: a route from the figure's list, or `null`.
- `evidence.p`: number of the paragraph (from 1) in that section to highlight.
- `evidence.quote`: optional exact phrase inside that paragraph to mark.
- `open`: optional `{ url, title, find, near, snippet }`: the passage the answer
  rests on. When present, a new page is written for the answer and used in
  place of `navigate_to`.
- `page`: optional `{ heading, paragraphs: [..], caption }`: the chatbot's
  text for that page. server.js asks the model for it and checks it.

`GET /api/page?url=...` returns `{ url, html }` for a non-Wikipedia article. It only
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
   routes and sources, and its two colours in the style sheet (`--c-<id>`
   for its pages, `--cloth-<id>` for its binding). Its book appears on the
   shelf on its own.
3. Add `<id>.json` beside `server.js`, shaped like `levski.json`, so the
   chatbot knows who is speaking.

Nothing else changes: the page logic and the server are shared by all figures.

## Legal pages (fill in before publishing)

Every page ends with a footer linking to: About (who runs the site), Privacy,
Artificial intelligence, Sources and licences, and Accessibility. Near the end
of `index.html`, in `const SITE = {...}`, replace the placeholders with your
name or organisation, postal address and contact email; they appear on those
pages.

What the site does to keep the legal side simple:

- **No cookies, no analytics, no tracking.** Only the language and theme
  choice is kept in the browser.
- **No Google Fonts.** Loading them would send every visitor's IP address to
  Google, so the typeface (Old Standard TT, SIL Open Font License) is
  embedded in the page.
- **AI notice.** The chat panel always says the figures are AI simulations
  (EU AI Act transparency), with a link to a page explaining it.
- **Microphone notice.** Before the first use, visitors are told that their
  browser sends the recording to its speech service.
- **Wikipedia credit.** Built-in texts and live articles carry links to the
  article, its authors (history) and the CC BY-SA 4.0 licence.

These pages are a sound starting point, not legal advice. Have them checked
before launch, especially the privacy page, and update it if you add
analytics, accounts or anything else that collects data.

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

## Not built yet

- **3D avatars.** The oval portrait is a placeholder; mount a canvas in
  `#avatar`. It gets the class `speaking` while the figure talks.
- **Portraits** are loaded from Wikipedia when the page opens; offline, a
  monogram is shown.

## Licence

The texts about the figures are adapted from Wikipedia and are shared under
CC BY-SA 4.0. The embedded typeface, Old Standard TT, is under the SIL Open
Font License 1.1. Choose a licence for the code before publishing (add a
`LICENSE` file).
