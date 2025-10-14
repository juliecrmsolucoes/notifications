
# Firebase Push Notifications for Flutter

Tutorial de como adicionar notificações push num projeto Flutter.

## No Console Firebase

Clique em **Adicionar app** logo abaixo do nome do projeto e selecione **Flutter**:

<img src="tutorial2.jpg" alt="isolated" width="400"/>

## No projeto Flutter

Certifique que seu arquivo pubspec.yaml contem os pacotes do firebase `firebase_messaging` e `firebase_core`.

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: <latest_version>
  firebase_messaging: <latest_version>
  flutter_local_notifications: <latest_version>
```

### Configure o flutterfire

```bash
dart pub global activate flutterfire_cli
```

```bat
firebase login
```

Para selecionar o projeto e as plataformas:

```bat
flutterfire configure 
```

---
---

### Definir plataforma

Faça o **passo a passo** pra configurar sua plataforma, há um markdown para iOS (``FIREBASE_IOS.md``) e outro para Android (``FIREBASE_ANDROID.md``).

---
---

## Código

Adicione os seguintes services

### FirebaseMessagingService

Olhar o arquivo ``firebase_messaging_service.dart``

### LocalNotificationsService

Olhar o arquivo ``local_notifications_service.dart``

.

>IMPORTANTE: Verifique o **ICONE** setado no AndroidInitializationSettings -> "@mipmap/ic_launcher"

---

### Inicializar Firebase

No arquivo main (ou nas dependencias iniciais do projeto), coloque o código:

```dart
void main() async {
  // Crucial para garantir inicialização do Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Firebase
  await Firebase.initializeApp();

  // Inicializa o service do FlutterLocalNotification
  final localNotificationsService = LocalNotificationsService.instance();
  await localNotificationsService.init();

  // Inicializa o service do FirebaseMessaging
  final firebaseMessagingService = FirebaseMessagingService.instance();
  await firebaseMessagingService.init(localNotificationService: localNotificationsService);

  runApp(const MyApp());
}
```
