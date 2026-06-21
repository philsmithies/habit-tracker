const CACHE_VERSION = "habit-tracker-v1"
const STATIC_ASSETS = [
  "/offline.html",
  "/icon-192.png",
  "/icon-512.png",
  "/icon-maskable-512.png",
  "/apple-touch-icon.png"
]

self.addEventListener("install", (event) => {
  event.waitUntil(caches.open(CACHE_VERSION).then((cache) => cache.addAll(STATIC_ASSETS)))
  self.skipWaiting()
})

self.addEventListener("activate", (event) => {
  event.waitUntil(
    caches.keys().then((keys) =>
      Promise.all(keys.filter((key) => key !== CACHE_VERSION).map((key) => caches.delete(key)))
    )
  )
  self.clients.claim()
})

self.addEventListener("fetch", (event) => {
  if (event.request.method !== "GET") return

  const url = new URL(event.request.url)
  if (url.origin !== self.location.origin) return

  if (event.request.mode === "navigate") {
    event.respondWith(fetch(event.request).catch(() => caches.match("/offline.html")))
    return
  }

  if (url.pathname.startsWith("/assets/") || STATIC_ASSETS.includes(url.pathname)) {
    event.respondWith(
      caches.match(event.request).then((cached) => {
        if (cached) return cached

        return fetch(event.request).then((response) => {
          if (response.ok) {
            const copy = response.clone()
            caches.open(CACHE_VERSION).then((cache) => cache.put(event.request, copy))
          }

          return response
        })
      })
    )
  }
})
