import 'dart:html' as html;

/// Clase para trabajar con la Web Notifications API
class WebNotification {
  /// Solicita permiso al usuario para mostrar notificaciones
  static Future<bool> requestPermission() async {
    final permission = await html.Notification.requestPermission();
    return permission == 'granted';
  }

  /// Muestra una notificación
  static void showNotification(String title, String body) {
    if (html.Notification.permission == 'granted') {
      html.Notification(
        title,
        body: body, // Aquí se pasa como NotificationOptions
      );
    } else {
      print('Permiso no concedido para notificaciones.');
    }
  }
}
