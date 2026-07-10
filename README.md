# Włoski z korepetycji

Notatki, transkrypcje i listy słówek z korepetycji z języka włoskiego, publikowane jako blog na GitHub Pages (Hugo + PaperMod).

## Struktura

- `raw/` — oryginalne nagrania (.mov, tylko dźwięk). Nie są commitowane do repo (patrz `.gitignore`), trzymane lokalnie/w backupie.
- `transcripts/` — surowe transkrypcje nagrań, jedna na lekcję.
- `content/posts/` — gotowe notatki z lekcji publikowane jako posty bloga.

## Workflow dla nowej lekcji

1. Nagranie trafia do `raw/RRRR-MM-DD-opis.mov`.
2. Transkrypcja trafia do `transcripts/RRRR-MM-DD-opis.md`.
3. Na jej podstawie tworzymy post: `hugo new content posts/RRRR-MM-DD-opis.md` (archetyp w `archetypes/posts.md` daje gotowy szkielet z sekcją notatek i tabelą słówek).
4. Usuwamy `draft = true`, commitujemy i pushujemy na `main` — GitHub Actions (`.github/workflows/hugo.yaml`) automatycznie buduje i publikuje stronę.

## Podgląd lokalny

```
hugo server -D
```
