# EditRemote Online Help

Questo progetto contiene il sito statico della guida online.

## Pubblicazione su GitHub Pages (branch main)

1. Crea un nuovo repository su GitHub (vuoto).
2. Esegui i comandi:

`ash
git init
git add .
git commit -m "Initial online help site"
git branch -M main
git remote add origin https://github.com/<utente>/<repo>.git
git push -u origin main
`

3. In GitHub: Settings > Pages
   - Source: Deploy from a branch
   - Branch: main
   - Folder: /(root)

## Aggiornamento contenuti

- Modifica i file HTML principali e le risorse in assets/.
- Esegui commit e push.
