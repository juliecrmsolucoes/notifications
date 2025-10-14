
# Firebase Push Notifications for Flutter

Tutorial de como adicionar notificações push num projeto Flutter.

## No Console Firebase

Clique em **Adicionar app** logo abaixo do nome do projeto

Selecione **Flutter**:

![Texto Alternativo](tutorial2.jpg)

## No projeto Flutter

Certifique que seu arquivo pubspec.yaml contem os pacotes do firebase `firebase_messaging` e `firebase_core`.

Abra o seu arquivo pubspec.yaml e adicione os seguintes pacotes:

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: <latest_version>
  firebase_messaging: <latest_version>
```

### Configurar flutterfire

```bash
> dart pub global activate flutterfire_cli
```

```bat
> firebase login
```

Para selecionar o projeto e as plataformas:

```bat
> flutterfire configure 
```

### Inicializar Firebase

No arquivo main (ou nas dependencias iniciais do projeto), coloque o código:

```dart
await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
```

---
_
>IMPORTANTE: Verifique o icone setado no AndroidInitializationSettings - "@mipmap/ic_launcher"
