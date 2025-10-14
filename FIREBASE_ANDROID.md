
# ANDROID Push Notifications for Flutter — passo a passo

> Objetivo: adicionar notificações push em ANDROID num projeto Flutter já existente, usando **Firebase Cloud Messaging (FCM)**.

---

>Certifique-se de que o arquivo de configuração nativo do Firebase para Android está no local correto.

- Arquivo Necessário: **google-services.json**

- Localização: Na pasta **android/app** do seu projeto.

>Se não o tiver, baixe-o do Firebase Console.

## 🧱 Fase 2: Configurar Gradle (Android) `android/build.gradle`

A versão 10+ do plugin agora depende do desugaring para oferecer suporte a notificações agendadas, com compatibilidade com versões anteriores do Android. Os desenvolvedores precisarão atualizar o arquivo Gradle do aplicativo para habilitar a dessugarização, mesmo que não usem notificações agendadas. Consulte o link sobre desugaring para obter mais detalhes, mas, para sua conveniência, você pode expandir abaixo para ver as partes relevantes, dependendo se o seu aplicativo possui um arquivo build.gradle ou build.gradle.kts.

### Groovy - build.gradle

```gradle
android {
    defaultConfig {
        // Add the line below
        multiDexEnabled true
    }

    compileOptions {
        // Add the line below
        coreLibraryDesugaringEnabled true
        // Verifique se o java é 11 ou maior
        sourceCompatibility JavaVersion.VERSION_11
        targetCompatibility JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }
}

dependencies {
    // Add the line below
    coreLibraryDesugaring 'com.android.tools:desugar_jdk_libs:2.1.4'
}
```

---

**Observe** que o plugin utiliza o plugin Android Gradle (AGP) 8.6.0 para aproveitar essa funcionalidade. Portanto, para garantir a segurança, os aplicativos devem usar, **NO MÍNIMO**, a mesma versão.

```gradle
buildscript {
   ...

    dependencies {
        classpath 'com.android.tools.build:gradle:8.6.0'
        ...
    }
```

Ou se o seu aplicativo estiver usando a nova sintaxe declarativa do Plugin DSL, o arquivo a ser atualizado será android/settings.gradle ou android/settings.gradle.kts e será semelhante ao seguinte

```gradle
plugins {
    ...
    id 'com.android.application' version '8.6.0' apply false
    ...
}
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

>Há relatos de que habilitar a desaçucaração pode resultar em travamentos de aplicativos do Flutter no Android 12L e versões superiores. Isso seria um problema com o próprio Flutter, não com o plugin. Uma possível solução é adicionar a biblioteca WindowManager como dependência: ``implementation 'androidx.window:window:1.0.0'`` e ``implementation 'androidx.window:window-java:1.0.0'``
---

>Para arquivos em kotlin (.kts) pesquisar no próprio package (<https://pub.dev/packages/flutter_local_notifications#-android-setup>) por ``Kotlin - build.gradle.kts``.

### Configuração do AndroidManifest

Anteriormente, o plugin especificava todas as permissões necessárias para todos os recursos suportados pelo plugin em seu próprio arquivo AndroidManifest.xml, para que os desenvolvedores não precisassem fazer isso no arquivo AndroidManifest.xml de seus próprios aplicativos. A partir da versão 16, o plugin agora especifica apenas o mínimo necessário e as permissões POST_NOTIFICATIONS e VIBRATE.

```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.VIBRATE"/>
```

### Para lidar com notificações agendadas, são necessárias as seguintes alterações

Adicione boot completed

```xml
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
```

E adicione o código abaixo dentro de ``<application>``

```xml
<receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver" />
<receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver">
    <intent-filter>
        <action android:name="android.intent.action.BOOT_COMPLETED"/>
        <action android:name="android.intent.action.MY_PACKAGE_REPLACED"/>
        <action android:name="android.intent.action.QUICKBOOT_POWERON" />
        <action android:name="com.htc.intent.action.QUICKBOOT_POWERON"/>
    </intent-filter>
</receiver>
```
