'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "05ad9c366c448f105363ef3fba6cf85b",
"assets/AssetManifest.bin.json": "514571eb917ec9eba81ea177bffb3c85",
"assets/AssetManifest.json": "1d7f4fecda3c630c112e4516265596c5",
"assets/assets/fonts/Sora-Regular.ttf": "7d1640025ba3f9d030e88c09820c2da7",
"assets/assets/images/africa.png": "cb2faa4864b0a2f51649dcda124cb700",
"assets/assets/images/agenda.png": "bd34ea20318f84de73982ea52be7c3d1",
"assets/assets/images/appbarlogo.png": "9e4cd4363e4968c4344b356339f09a7a",
"assets/assets/images/appbarlogo.svg": "8f7698d295cdf77e57c98e0ad8d7f1ad",
"assets/assets/images/appicon.png": "077f459676ee115d22793cada6ab2b1b",
"assets/assets/images/background.png": "b172caf1bdbcd2e1c6b92b4a4badde27",
"assets/assets/images/banner.png": "f2d457a7d229de4935e9b53aaa593893",
"assets/assets/images/chat.png": "c6b291cbd5e12e465c5144592a4986b8",
"assets/assets/images/dancing.jpg": "e21303f8c863d3ed41a67d2f056e3300",
"assets/assets/images/dilogo.png": "6986b56191baffd6cf5478b6c69d5f1b",
"assets/assets/images/events.png": "9e3f285799832cdd0fc2eb7a074e5c0e",
"assets/assets/images/files.png": "54abf0b12cd6b84f1c6578423eba3750",
"assets/assets/images/galleryicon.png": "fb8527a3b89bb619498347304091be03",
"assets/assets/images/gather.png": "d0d306bc2b347b236c97c9a5dd0b65f2",
"assets/assets/images/gold.png": "d76730af5370d7e204eaab7977031c4f",
"assets/assets/images/homebanner.png": "11effd6f591e5973e7e6aa633136b041",
"assets/assets/images/homeicon.png": "5fba453828fa39bec165c86ca3beb757",
"assets/assets/images/landing.png": "7391b7fd2767ce6703778d8e87f96ee8",
"assets/assets/images/listview.png": "dec076d2a3a497b1c9c6eaf183ce8ab1",
"assets/assets/images/live.png": "ce39b992e88ce5218686a4eb2cfbbab3",
"assets/assets/images/logo.png": "5d74911b2b031820fed65aed4ca58ede",
"assets/assets/images/logo1.png": "4c397cc8104667845fd532a8da18be5f",
"assets/assets/images/mainlogo.png": "5086550988b9dd61c897faa4da25fc0c",
"assets/assets/images/megaphone.png": "424ebc189672f81117ca830f11287695",
"assets/assets/images/microphone.png": "340ba7140244213e53d6a6d529527f31",
"assets/assets/images/onboarding1.jpg": "f2a85eb638d5b6a194c09faeaaffdd28",
"assets/assets/images/onboarding2.jpg": "db814905c909ad88547b73622f07ec26",
"assets/assets/images/onboarding3.jpg": "c8749591c690904da67b69be6db5aa05",
"assets/assets/images/ongoing.jpg": "bf3307ff2ee9378bfe8a0d233087e216",
"assets/assets/images/paperback.png": "d388209503a232c7f831caccc9b7998b",
"assets/assets/images/paperbg.png": "2407e7bd8826dea419ebe2d3fc321a38",
"assets/assets/images/partners.jpg": "540a1eb440a9a56bb889f1b17ee7148e",
"assets/assets/images/qrcode.png": "8c50faa485bc092f89cff75307ef3f7a",
"assets/assets/images/registration.jpg": "9e11358bee2ee867506f34f62e04cfb4",
"assets/assets/images/resources.png": "41087e9a49a1b0e757d34a8251b68785",
"assets/assets/images/rogers.png": "a06ef6e7dec9b7bf45a70560da6767c4",
"assets/assets/images/schedule.png": "561da8cd0e458f76ad7bc6ffc4ed2f16",
"assets/assets/images/sponsors.jpg": "b7d14b523750ab166c3cd530aa868036",
"assets/assets/images/thankyou.jpg": "12e03607dc7259ab289475e2e08263e8",
"assets/assets/images/thomas.jpg": "4bbc2c7513c3608f0122fb58c78a04eb",
"assets/assets/images/trilogo.png": "5b52c6e020bcbf3ddd627eccc3c10f66",
"assets/assets/images/user.jpg": "4d0f88d6fb0f198b56943d410b1ae0f5",
"assets/assets/images/vote.png": "09ac71d79586a8ec0ca79385137f9a28",
"assets/assets/images/watermark.png": "3264159abacdd1a020f97d8c9d2d18b5",
"assets/FontManifest.json": "476f468610c5836f716bb8b82cf80ed4",
"assets/fonts/MaterialIcons-Regular.otf": "61181ae8da76cf8f211d522911966cd9",
"assets/NOTICES": "1203f9c679a0b129668e10c25953842b",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"favicon.ico": "4d6338c280de9ce2c092aa1a2186ede3",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"flutter_bootstrap.js": "57b9f150d6acd2dc4bd96f520d9c4acf",
"icons/apple-touch-icon.png": "95c2aff33c032ffa59c70dd09499eac8",
"icons/favicon-16x16.png": "6c24c4c80ee35cc14dfc27462c1dd6fd",
"icons/favicon-32x32.png": "8cece7db97254bb7bcca4be701c4ebb0",
"icons/favicon.ico": "4d6338c280de9ce2c092aa1a2186ede3",
"icons/Icon-192.png": "d413c51b3016616b9a11f39a75797814",
"icons/Icon-512.png": "c308d66196d1ea035c13089107900403",
"icons/Icon-maskable-192.png": "d413c51b3016616b9a11f39a75797814",
"icons/Icon-maskable-512.png": "c308d66196d1ea035c13089107900403",
"index.html": "ce602d3970ce79eb8dde6fce728a18f4",
"/": "ce602d3970ce79eb8dde6fce728a18f4",
"main.dart.js": "1474520e5c6ce2058f884c6593557967",
"manifest.json": "cf6a7f76b2f619f1cce0cca01d999521",
"splash/img/light-background.png": "2407e7bd8826dea419ebe2d3fc321a38",
"vercel.json": "c10d4f6ede34a63c54e099a7fef5cd80",
"version.json": "7ff139aa5b0dda58f7d476cb6ee7f224"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
