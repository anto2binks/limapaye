#!/bin/sh
# Génère :
#  - index.html : l'appli web (installable sur l'écran d'accueil, fonctionne hors connexion via sw.js)
#  - sw.js : cache hors connexion, versionné à chaque build
#  - dist/fiche-paie.html : application en UN SEUL fichier (pdf.js intégré)
cd "$(dirname "$0")"
python3 - <<'PY'
import hashlib
src = open("fichepaie.html", encoding="utf-8").read()
lib = open("vendor/pdf.min.js", encoding="utf-8").read()
worker = open("vendor/pdf.worker.min.js", encoding="utf-8").read()
tag = '<script src="vendor/pdf.min.js"></script>'
assert src.count(tag) == 1

head = ('<!doctype html>\n<html lang="fr">\n<head>\n<meta charset="utf-8">\n'
        '<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">\n')
pwa = ('<link rel="manifest" href="manifest.webmanifest">\n'
       '<meta name="theme-color" content="#2f3fd0">\n'
       '<meta name="apple-mobile-web-app-capable" content="yes">\n'
       '<meta name="mobile-web-app-capable" content="yes">\n'
       '<meta name="apple-mobile-web-app-title" content="Fiche de paie">\n'
       '<meta name="apple-mobile-web-app-status-bar-style" content="default">\n'
       '<link rel="apple-touch-icon" href="icons/apple-touch-icon.png">\n'
       '<link rel="icon" type="image/png" sizes="192x192" href="icons/icon-192.png">\n')
import datetime
from zoneinfo import ZoneInfo
stamp = datetime.datetime.now(ZoneInfo("Europe/Paris")).strftime("%d/%m/%Y %H:%M")
sw_reg = ('<script>window.APP_BUILD = "' + stamp + '";\n'
          'if ("serviceWorker" in navigator && (location.protocol === "https:" || location.hostname === "localhost")) {\n'
          '  var hadController = !!navigator.serviceWorker.controller, reloaded = false;\n'
          '  navigator.serviceWorker.addEventListener("controllerchange", function () { if (hadController && !reloaded) { reloaded = true; location.reload(); } });\n'
          '  window.addEventListener("load", function () { navigator.serviceWorker.register("sw.js", { updateViaCache: "none" }).then(function (r) { r.update(); }).catch(function () {}); });\n'
          '  document.addEventListener("visibilitychange", function () { if (document.visibilityState === "visible") navigator.serviceWorker.getRegistration().then(function (r) { if (r) r.update(); }); });\n'
          '}\n'
          'var vb = document.getElementById("app-build"); if (vb) vb.textContent = "Version du " + window.APP_BUILD;</script>\n')
foot = "\n</body>\n</html>\n"

index = head + pwa + "</head>\n<body>\n" + src + "\n" + sw_reg + foot
open("index.html", "w", encoding="utf-8").write(index)

h = hashlib.sha256((index + lib + worker).encode()).hexdigest()[:12]
sw = open("sw.template.js", encoding="utf-8").read().replace("__VERSION__", h)
open("sw.js", "w", encoding="utf-8").write(sw)

assert "</script" not in lib and "</script" not in worker
inline = ('<script id="pdfjs-worker-src" type="text/plain">' + worker + '</script>\n'
          '<script>window.PDFJS_WORKER_URL = URL.createObjectURL(new Blob([document.getElementById("pdfjs-worker-src").textContent], {type: "text/javascript"}));</script>\n'
          '<script>' + lib + '</script>')
import os
os.makedirs("dist", exist_ok=True)
open("dist/fiche-paie.html", "w", encoding="utf-8").write(head + "</head>\n<body>\n" + src.replace(tag, inline) + '\n<script>window.APP_BUILD = "' + stamp + '"; var vb = document.getElementById("app-build"); if (vb) vb.textContent = "Version du " + window.APP_BUILD;</script>' + foot)
PY
