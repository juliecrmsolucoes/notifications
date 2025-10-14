
# ANDROID Push Notifications for Flutter — passo a passo

> Objetivo: adicionar notificações push em ANDROID num projeto Flutter já existente, usando **Firebase Cloud Messaging (FCM)**.

---

## Fase 1: Configuração do Flutter e Pacotes

### 1.1 Adicionar Dependências

Abra o seu arquivo pubspec.yaml e adicione os seguintes pacotes:

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: <latest_version>
  firebase_messaging: <latest_version>
```

### 1.2 Verificar Arquivo de Configuração do iOS

Certifique-se de que o arquivo de configuração nativo do Firebase para iOS está no local correto.

- Arquivo Necessário: **GoogleService-Info.plist**

- Localização: Na pasta **ios/Runner/** do seu projeto.

Se não o tiver, baixe-o do Firebase Console (Project Settings > General > Your Apps > iOS) e coloque-o na pasta ios/Runner.

## Fase 2: Configuração do Servidor Apple (Important)

O Firebase precisa de autorização da Apple para enviar notificações em nome do seu aplicativo. Isso é feito com uma Chave de Autenticação APNs (.p8).

### 2.1 Gerar a Chave de Autenticação APNs (.p8)

- Acesse o Apple Developer Account.
- Vá para Certificates, IDs & Profiles e, em seguida, Keys.

- Clique no botão azul (+) para criar uma nova chave.

- Dê um nome (ex: "FCM Push Key") e marque o serviço Apple Push Notifications service (APNs).

- Clique em "Configure" e selecione no campo Environment "Sandbox & Production". Salve.  

- Clique em Continue e depois em Register.

- Na próxima tela, clique em Download para baixar o arquivo .p8.

>IMPORTANTE: Guarde este arquivo em segurança, pois ele só pode ser baixado uma vez. Anote o Key ID (identificador da chave) e o seu Team ID (identificador da sua equipe de desenvolvedor), visíveis nesta página.

### 2.2 Carregar a Chave no Firebase

- Acesse o Firebase Console.

- Vá em Project Settings (⚙️) > Cloud Messaging.

- Na seção Apple app configuration, clique em Upload para APNs Authentication Key.

- Carregue o arquivo .p8 que você baixou.

- Preencha o Key ID e o seu Team ID nos campos apropriados.

- Resultado: O Firebase agora pode se comunicar com a Apple para entregar suas notificações.

## Fase 3: Configuração Nativada no Xcode (Mandatória no Mac)

Essas configurações não podem ser feitas no Windows e são obrigatórias para que o iOS permita que seu app receba notificações.

### 3.1 Abrir o Projeto no Xcode

- No seu Mac, navegue até a pasta ios do seu projeto.

- Abra o arquivo Runner.xcworkspace (e não o .xcodeproj).

### 3.2 Habilitar Capabilities

- No Xcode, selecione o projeto Runner no painel esquerdo.

- Selecione o target Runner.

- Vá para a aba Signing & Capabilities.

- Clique no botão + Capability e adicione:

- Push Notifications

- Clique novamente no botão + Capability e adicione:

- Background Modes

- Na seção Background Modes, marque a caixa Remote notifications.

>Importância: Isso permite que o aplicativo seja acordado em segundo plano para processar notificações.

## Fase 4: Código Flutter/Dart

Você precisa de código para inicializar o Firebase, pedir permissão ao usuário (obrigatório no iOS) e definir como as mensagens serão tratadas (FirebaseMessagingService).

## Fase 5: flutter_local_notification Setup

Vá para ios/Runner/AppDelegate.swift

### Importe o package

```swift
import flutter_local_notifications
```

### Insira o código

Dentro da função principal (após ``-> Bool`` e antes de ``GeneratedPluginRegistrant.register(with: self)``) insira:

```swift
FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
  GeneratedPluginRegistrant.register(with: registry)
}

if #available(iOS 10.0, *) {
  UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
}
```

## Fase 6: Teste Final

Para testar se tudo está funcionando:

- Execute seu aplicativo no dispositivo iOS físico (simuladores não funcionam bem com FCM).

- Coloque o aplicativo em segundo plano ou feche-o completamente.

- Acesse o Firebase Console e vá em Engage > Messaging.

- Crie uma nova campanha de notificação (ou use o Notifications composer).

- Defina o título, o corpo da mensagem e selecione o seu aplicativo iOS como alvo.

- Envie a mensagem de teste.

>Se a notificação aparecer no seu dispositivo com o app em segundo plano ou fechado, a configuração foi bem-sucedida. Se aparecer apenas com o app aberto (e você tiver implementado a notificação local), mas não em segundo plano, o problema está provavelmente nas Capabilities do Xcode (Fase 3).
