importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

firebase.initializeApp({
  apiKey: 'AIzaSyAFynOb7cl555DkSCO0I4C51nEFGAEqpgc',
  appId: '1:1065762459264:web:3cb60f2efd86c03733e065',
  messagingSenderId: '1065762459264',
  projectId: 'dt-live-web',
  authDomain: 'dt-live-web.firebaseapp.com',
  storageBucket: 'dt-live-web.firebasestorage.app',
});
// Necessary to receive background messages:
const messaging = firebase.messaging();

messaging.onBackgroundMessage(messaging, (payload) => {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);
});
