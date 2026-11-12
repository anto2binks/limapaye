#!/bin/sh
# Génère :
#  - index.html : page autonome qui charge pdf.js depuis vendor/
#  - dist/fiche-paie.html : application en UN SEUL fichier (pdf.js intégré), à ouvrir directement dans un navigateur
cd "$(dirname "$0")"
HEAD='<!doctype html>
<html lang="fr">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
</head>
<body>
'
{ printf '%s' "$HEAD"; cat fichepaie.html; printf '\n</body>\n</html>\n'; } > index.html
mkdir -p dist
python3 - <<'PY'
src = open("fichepaie.html", encoding="utf-8").read()
lib = open("vendor/pdf.min.js", encoding="utf-8").read()
worker = open("vendor/pdf.worker.min.js", encoding="utf-8").read()
assert "</script" not in lib and "</script" not in worker
inline = ('<script id="pdfjs-worker-src" type="text/plain">' + worker + '</script>\n'
          '<script>window.PDFJS_WORKER_URL = URL.createObjectURL(new Blob([document.getElementById("pdfjs-worker-src").textContent], {type: "text/javascript"}));</script>\n'
          '<script>' + lib + '</script>')
tag = '<script src="vendor/pdf.min.js"></script>'
assert src.count(tag) == 1
out = src.replace(tag, inline)
head = ('<!doctype html>\n<html lang="fr">\n<head>\n<meta charset="utf-8">\n'
        '<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">\n</head>\n<body>\n')
open("dist/fiche-paie.html", "w", encoding="utf-8").write(head + out + "\n</body>\n</html>\n")
PY
