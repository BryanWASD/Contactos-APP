// firebase-messaging-sw.js
importScripts('https://www.gstatic.com/firebasejs/9.18.0/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/9.18.0/firebase-messaging.js');

firebase.initializeApp({
    
        apiKey: "AIzaSyDBkkhgbVh8xYDLpuuS2q1ivVF5AxJzF-I",
        authDomain: "flutter-3c0eb.firebaseapp.com",
        projectId: "flutter-3c0eb",
        storageBucket: "flutter-3c0eb.firebasestorage.app",
        messagingSenderId: "291649233099",
        appId: "1:291649233099:web:51a9c362e35a836e013b4e",
        measurementId: "G-B64YMB9D5Z",
});

const messaging = firebase.messaging();

// Maneja mensajes en segundo plano
messaging.onBackgroundMessage((payload) => {
    console.log('[firebase-messaging-sw.js] Received background message ', payload);

    const notificationTitle = payload.notification.title;
    const notificationOptions = {
        body: payload.notification.body,
    };

    self.registration.showNotification(notificationTitle, notificationOptions);
});
