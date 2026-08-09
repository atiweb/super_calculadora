# Translations for the online user guide

`../index.html` ships its text in **English, inline**. Every translatable
string sits in an element with a `data-i18n` key, and each file here maps
those keys to one language:

```js
i18nRegister("en", {
  "site-nav-01": "Getting Started",
  "tools-algebra-01": "Algebra — Polynomials in Several Variables"
});
```

The payload is a plain JSON object; the one-line `i18nRegister(...)` wrapper
is there so the browser can load it with a `<script>` tag. A bare `.json`
would need `fetch()`, which browsers block for local files — the page would
then be stuck in English whenever `index.html` is opened straight from disk
instead of through a web server.

The keys are `<section-id>-<nn>`, taken from the `id` of the section the text
belongs to, so a key tells you where on the page it appears.

## Why the English is also in the HTML

So the page still reads with JavaScript disabled, and so crawlers index it.
English is snapshotted from the page itself at startup and never fetched —
switching back to it is instant and works offline. `en.js` exists as the
reference translators compare against; a test keeps the two identical.

## Adding a language

1. Copy `en.js` to `<code>.js` (ISO 639-1, e.g. `pt.js`) and translate
   the values, and change the code in the `i18nRegister("…"` call.
   **Leave the keys alone.**
2. Add one button to the language pill in `../index.html`:

   ```html
   <button class="lbtn" data-lang="pt" onclick="setLang('pt')">PT</button>
   ```

That is all — the loader picks the file up by name.

## What the tests check

`flutter test test/docs_i18n_test.dart` verifies that every language file
covers exactly the keys the page uses (no missing, no leftovers), that no
value is empty, and that the inline English still matches `en.js`. So an
incomplete translation fails the build instead of shipping half a page.

A few values contain inline markup (`<strong>`, `<em>`, `<code>`, `<a>`,
`<pre>`) — keep the tags, translate the text around them.

## Untranslated keys

A key missing from a language file is not fatal at runtime: that string falls
back to English. The test is stricter than the page on purpose, so gaps are
noticed while editing rather than by a reader.
