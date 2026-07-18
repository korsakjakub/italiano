---
name: nowa-lekcja
description: Turn a new Italian-tutoring recording (.mov) into a transcript and a published Hugo blog post with lesson notes and a vocab list. Use when the user says there's a new recording, asks to transcribe a lesson, or asks to add a lesson post to this site.
user-invocable: true
---

# /nowa-lekcja — nagranie → transkrypcja → post

Pełny pipeline dla tego repo: nagranie korepetycji (.mov, tylko dźwięk) →
transkrypcja lokalna → notatki + słówka jako post na blogu Hugo → publikacja
na GitHub Pages.

## Krok 1 — znajdź i przenieś nagranie

Nowe pliki `.mov` zwykle lądują w katalogu głównym repo (nie w `raw/`).
Znajdź je: `find . -maxdepth 1 -iname "*.mov"`.

Przenieś do `raw/` z nazwą `RRRR-MM-DD-lekcja.mov`, biorąc datę z nazwy
oryginalnego pliku (np. `2026-07-18 09-36-07.mov` → `raw/2026-07-18-lekcja.mov`).
Jeśli jest kilka plików albo nazwa nie ma daty, zapytaj użytkownika.

## Krok 2 — transkrypcja

Uruchom skrypt (nie wywołuj `mlx_whisper` ręcznie z zapamiętanymi flagami —
wszystkie ustawienia są już w skrypcie):

```
./scripts/transcribe.sh raw/RRRR-MM-DD-lekcja.mov RRRR-MM-DD-lekcja
```

To zwykle trwa kilka-kilkanaście minut dla godzinnego nagrania — uruchom
w tle (`run_in_background: true`) i poczekaj na notyfikację zamiast
odpytywać ręcznie (proces jest długi, ale niepolling — nie sprawdzaj co
kilka sekund; zaufaj powiadomieniu o zakończeniu w tle).

Wynik trafia do `transcripts/RRRR-MM-DD-lekcja.{txt,srt,vtt,json,tsv}`.
Te pliki **nigdy nie trafiają do gita** (są w `.gitignore`, tak jak `raw/`) —
zostają wyłącznie lokalnie, są tylko materiałem źródłowym do notatek.

Szybka kontrola jakości: `grep -c '^Ok\.$' transcripts/RRRR-MM-DD-lekcja.txt`
(albo inny powtarzający się fragment) — jeśli liczba jest podejrzanie
wysoka (dziesiątki/setki), model wpadł w pętlę halucynacji na ciszy;
przejrzyj plik `.txt` pod kątem długich bloków identycznych linii zanim
zaczniesz pisać notatki na tej podstawie.

## Krok 3 — notatki i słówka jako post

Przeczytaj cały `transcripts/RRRR-MM-DD-lekcja.txt`. Nagrania są dwujęzyczne
(polski + włoski, czasem pomieszane w jednym zdaniu) — czytaj po sensie, nie
dosłownie; transkrypcja bywa lekko krzywa fonetycznie (np. "gitarra" zamiast
"chitarra", "passaggiare" zamiast "passeggiare") — koryguj oczywiste błędy
w notatkach, nie przepisuj ich wprost.

Utwórz post z archetypu:

```
hugo new content posts/RRRR-MM-DD-lekcja.md
```

Wypełnij wg formatu ustalonego w istniejących postach
(`content/posts/2026-07-10-lekcja.md`, `content/posts/2026-07-18-lekcja.md`):
- `draft = false`
- `title` — krótki, konkretny, z tematami gramatycznymi lekcji
- `tags` — kluczowe tematy gramatyczne
- sekcja `## Notatki` — zwięzłe wyjaśnienie gramatyki/tematów omówionych na
  lekcji, z przykładami zdań z transkrypcji
- sekcja `## Słówka` — tabela Italiano / Polski / Przykład, tylko słówka i
  zwroty faktycznie nowe lub warte utrwalenia z tej lekcji (nie każde słowo
  z transkrypcji)

## Krok 4 — build i weryfikacja

```
rm -rf public resources .hugo_build.lock
hugo --gc
```

Sprawdź wygenerowany HTML posta (`public/posts/RRRR-MM-DD-lekcja/index.html`)
— nagłówek, tabela, brak błędów budowania. Posprzątaj:
`rm -rf public resources .hugo_build.lock`.

## Krok 5 — commit i push

Użytkownik ustalił, że dla tego repo commit + push po dodaniu posta robimy
od razu, bez dodatkowego pytania za każdym razem:

```
git add content/posts/RRRR-MM-DD-lekcja.md
git commit -m "..."
git push
```

**Nigdy nie dodawaj** `raw/` ani `transcripts/` do commita — zostają lokalnie
(patrz `.gitignore`). Jeśli kiedykolwiek trzeba zmienić inne pliki (np.
`hugo.toml`, layouty, `.github/workflows/`), potwierdź z użytkownikiem przed
commitem tak jak zwykle — ta automatyczna zgoda dotyczy tylko rutynowego
dodawania postów z lekcji.
