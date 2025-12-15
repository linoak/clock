const CACHE_NAME = 'pomodoro-cache-v1';
const ASSETS = [
  '/',
  '/index.html',
  '/manifest.json',
  '/assets/audio/下課音樂.mp3',
  '/assets/audio/上課提醒.mp3'
];

self.addEventListener('install', (event) => {
  event.waitUntil(caches.open(CACHE_NAME).then((cache) => cache.addAll(ASSETS)));
  self.skipWaiting();
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((keys) =>
      Promise.all(keys.map((k) => (k !== CACHE_NAME ? caches.delete(k) : null)))
    )
  );
  self.clients.claim();
});

self.addEventListener('fetch', (event) => {
  const req = event.request;
  event.respondWith(
    caches.match(req).then((cached) => {
      const fetchPromise = fetch(req).then((networkRes) => {
        if (req.method === 'GET' && req.url.startsWith(self.location.origin)) {
          caches.open(CACHE_NAME).then((cache) => cache.put(req, networkRes.clone()));
        }
        return networkRes;
      }).catch(() => cached);
      return cached || fetchPromise;
    })
  );
});