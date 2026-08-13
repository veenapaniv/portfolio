# Veenapani Veena — Portfolio (Flutter Web)

A 6-page Flutter web portfolio: Home, Experience, Projects, Skills, Resume, Contact.

## Run locally

1. Install the Flutter SDK: https://docs.flutter.dev/get-started/install
2. From this folder:
   ```
   flutter pub get
   flutter run -d chrome
   ```

## Project structure

```
lib/
  main.dart              app entry + routes
  theme/                 colors, fonts, accent helper
  data/                  all site content (edit here to update copy)
  widgets/                shared nav bar, footer, cards, page layout
  pages/                  one file per page
assets/
  resume.pdf              shown inline on the Resume page + downloadable
.github/workflows/
  deploy.yml               auto-builds & deploys to GitHub Pages on push
```

To update any text on the site (experience bullets, project descriptions, skills,
awards, contact info), edit `lib/data/portfolio_data.dart` — every page reads
from that single file.

To swap in a real headshot: replace the "VV" gradient avatar in
`lib/pages/home_page.dart` (`_CredentialsCard`) with
`Image.asset('assets/headshot.jpg')`, add the image to `assets/`, and list it
under `flutter: assets:` in `pubspec.yaml`.

## Deploying to GitHub Pages (no local Flutter install needed)

1. Create a new GitHub repo (e.g. `portfolio`) under your account `veenapaniv`
   and push this whole folder to its `main` branch.
2. In the repo, go to **Settings → Pages** and set **Source** to
   **GitHub Actions**.
3. Push to `main` — the included workflow (`.github/workflows/deploy.yml`)
   will build the Flutter web app and publish it automatically. Check the
   **Actions** tab for progress; the live URL appears there once it finishes.

**One setting to check based on your repo name:**
- If your repo is named `veenapaniv.github.io` (a user/organization page),
  open `.github/workflows/deploy.yml` and change the `--base-href` line to:
  ```
  flutter build web --release --base-href "/"
  ```
- If your repo has any other name (e.g. `portfolio`), leave the workflow as-is
  — it already uses `/reponame/` automatically.

## Routing note

Page links use hash-based URLs (e.g. `yoursite.com/#/experience`) rather than
clean paths. This is deliberate: GitHub Pages can't rewrite unknown paths back
to `index.html`, so a clean-path SPA route 404s on refresh or direct link.
Hash routing avoids that with zero extra configuration.
