#!/bin/sh
# Génère index.html (page autonome) à partir de fichepaie.html
cd "$(dirname "$0")"
{ printf '<!doctype html>\n<html lang="fr">\n<head>\n<meta charset="utf-8">\n<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">\n</head>\n<body>\n'; cat fichepaie.html; printf '\n</body>\n</html>\n'; } > index.html
