
# Firebase Push Notifications for Flutter

Tutorial de como adicionar notificações push num projeto Flutter.

---

## 🔧 1. Pré-requisitos

- Flutter SDK utilizado neste projeto: `3.35.5`
- Node.js instalado (necessário para `flutterfire` CLI)
- Projeto Flutter existente
- **Projeto Firebase** criado
- Conta no [Firebase Console](https://console.firebase.google.com/)

---

### Console Firebase

>**Não** é necessáro clicar em **Adicionar app**, deixaremos para fazer isso via linha de comando!

---

## 🚀 2. Configurar Firebase e FlutterFire

Caso não tenha instalado a CLI rode o seguinte comando:

```bash
npm install -g firebase-tools
```

Faça login no Firebase com sua Conta do Google executando o seguinte comando:

```bash
firebase login
```

Execute no terminal (globalmente):

```bash
dart pub global activate flutterfire_cli
```

## 🔥 3. Vincular o Firebase ao Flutter

No terminal (na raiz do projeto Flutter):

```bash
flutterfire configure
```

Escolha o projeto Firebase criado e o app Android.

Isso vai gerar automaticamente os arquivos:

``lib/firebase_options.dart``

``google-services.json``

---

## 📱No projeto Flutter

### 🧱 4. Configurar Gradle (Android) `android/build.gradle`

Adicione o plugin do Google Services no `buildscript`:

```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.4.2'
    }
}
```

### 4.2 `android/app/build.gradle`

Aplique o plugin **no final do arquivo**:

```gradle
apply plugin: 'com.google.gms.google-services'
```

Garanta as versões mínimas:

```gradle
android {
    namespace "com.example.meuapp"
    compileSdkVersion 34

    defaultConfig {
        minSdkVersion 23
        targetSdkVersion 34
    }
}
```

### 4.3 Permissões (AndroidManifest.xml)

Abra `android/app/src/main/AndroidManifest.xml` e adicione:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```

---

Certifique que seu arquivo pubspec.yaml contem os pacotes do firebase `firebase_messaging` e `firebase_core`.

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: <latest_version>
  firebase_messaging: <latest_version>
  flutter_local_notifications: <latest_version>
```

---

### Definir plataforma

Siga o **passo a passo** pra configurar sua plataforma ANTES de prosseguir, há um markdown para iOS (``FIREBASE_IOS.md``) e outro para Android (``FIREBASE_ANDROID.md``).

---
---
---

## 5. Código

Após configurar de acordo com sua plataforma, continue com o Flutter.

### Adicione os seguintes services

``FirebaseMessagingService`` -> Olhar o arquivo ``firebase_messaging_service.dart``

``LocalNotificationsService`` -> Olhar o arquivo ``local_notifications_service.dart``

.

>IMPORTANTE: Verificar o **ICONE** no AndroidInitializationSettings -> "@mipmap/ic_launcher"

---

### Inicializar Firebase

No arquivo main (ou nas dependencias iniciais do projeto), coloque o código:

```dart
void main() async {
  // Crucial para garantir inicialização do Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Inicializa o service do FlutterLocalNotification
  final localNotificationsService = LocalNotificationsService.instance();
  await localNotificationsService.init();

  // Inicializa o service do FirebaseMessaging
  final firebaseMessagingService = FirebaseMessagingService.instance();
  await firebaseMessagingService.init(localNotificationService: localNotificationsService);

  runApp(const MyApp());
}
```
