# Włoski z Karoliną

Notatki, transkrypcje i listy słówek z korepetycji z języka włoskiego, publikowane jako blog na GitHub Pages (Hugo, własny minimalny motyw).

## Struktura

- `raw/` — oryginalne nagrania (.mov, tylko dźwięk). Nie są commitowane do repo (patrz `.gitignore`), trzymane lokalnie/w backupie.
- `transcripts/` — surowe transkrypcje nagrań, jedna na lekcję.
- `content/posts/` — gotowe notatki z lekcji publikowane jako posty bloga.

## Workflow dla nowej lekcji

Cały pipeline (nagranie → transkrypcja → post) jest opisany jako skill
Claude Code: `.claude/skills/nowa-lekcja/SKILL.md` (uruchom `/nowa-lekcja`).
Skrót:

1. Nagranie trafia do `raw/RRRR-MM-DD-lekcja.mov`.
2. Transkrypcja: `./scripts/transcribe.sh raw/RRRR-MM-DD-lekcja.mov RRRR-MM-DD-lekcja` → `transcripts/RRRR-MM-DD-lekcja.*` (nigdy niecommitowane, patrz `.gitignore`).
3. Na jej podstawie tworzymy post: `hugo new content posts/RRRR-MM-DD-lekcja.md` (archetyp w `archetypes/posts.md` daje gotowy szkielet z sekcją notatek i tabelą słówek).
4. Usuwamy `draft = true`, commitujemy i pushujemy na `main` — GitHub Actions (`.github/workflows/hugo.yaml`) automatycznie buduje i publikuje stronę.

## Podgląd lokalny

```
hugo server -D
```
