/* Cache hors connexion de l'appli. Ne met en cache que le programme, jamais une fiche de paie. */
const CACHE = "fichepaie-ef9332b8be13";
const FILES = ["./", "index.html", "manifest.webmanifest", "vendor/pdf.min.js", "vendor/pdf.worker.min.js",
  "icons/icon-192.png", "icons/icon-512.png", "icons/icon-maskable-512.png", "icons/apple-touch-icon.png"];

self.addEventListener("install", (e) => {
  // cache: "reload" : on ignore le cache du navigateur pour être sûr d'avoir la nouvelle version
  e.waitUntil(caches.open(CACHE).then((c) => c.addAll(FILES.map((f) => new Request(f, { cache: "reload" })))).then(() => self.skipWaiting()));
});
self.addEventListener("activate", (e) => {
  e.waitUntil(caches.keys().then((keys) => Promise.all(keys.filter((k) => k !== CACHE).map((k) => caches.delete(k)))).then(() => self.clients.claim()));
});
self.addEventListener("fetch", (e) => {
  const req = e.request;
  if (req.method !== "GET" || new URL(req.url).origin !== location.origin) return;
  if (req.mode === "navigate") {
    // Page : réseau d'abord (pour avoir la dernière version), cache si hors connexion
    e.respondWith(fetch(req.url, { cache: "no-store", credentials: "same-origin" }).then((r) => { const copy = r.clone(); caches.open(CACHE).then((c) => c.put("index.html", copy)); return r; })
      .catch(() => caches.match("index.html")));
    return;
  }
  // Fichiers du programme
  e.respondWith(caches.match(req).then((hit) => hit || fetch(req).then((r) => {
    if (r.ok && /\/vendor\//.test(new URL(req.url).pathname)) { const copy = r.clone(); caches.open(CACHE).then((c) => c.put(req, copy)); }
    return r;
  })));
});
