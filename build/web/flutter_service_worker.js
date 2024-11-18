self.addEventListener('install', function(event) {
    event.waitUntil(
      caches.open('flutter-cache').then(function(cache) {
        return cache.addAll([
          '/', // Página principal
          '/index.html',
          '/static/js/main.js',
          '/static/css/main.css',
          '/icons/icon-192x192.png', // Agrega iconos o cualquier recurso importante
          '/manifest.json', // Asegúrate de que el manifiesto también esté disponible offline
          // Otros archivos estáticos que son esenciales para el funcionamiento de la app
        ]);
      })
    );
  });
  
  self.addEventListener('activate', function(event) {
    const cacheWhitelist = ['flutter-cache'];
  
    event.waitUntil(
      caches.keys().then(function(cacheNames) {
        return Promise.all(
          cacheNames.map(function(cacheName) {
            if (!cacheWhitelist.includes(cacheName)) {
              // Borrar las cachés antiguas
              return caches.delete(cacheName);
            }
          })
        );
      })
    );
  });
  
  self.addEventListener('fetch', function(event) {
    event.respondWith(
      caches.match(event.request).then(function(cachedResponse) {
        // Si la respuesta está en la caché, devuélvela
        if (cachedResponse) {
          return cachedResponse;
        }
  
        // Si no está en la caché, realiza la solicitud de red
        return fetch(event.request).then(function(networkResponse) {
          // Si la respuesta es exitosa, almacénala en la caché para futuras solicitudes
          if (networkResponse && networkResponse.status === 200) {
            caches.open('flutter-cache').then(function(cache) {
              cache.put(event.request, networkResponse.clone());
            });
          }
          return networkResponse;
        });
      })
    );
  });
  