plugins {
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "az.qiymet.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "az.qiymet.app"

        // 21, а не подставляемый Flutter'ом 24. Понижение сознательное:
        // в Азербайджане заметная доля рынка — телефоны на Android 5-6, а
        // приложение сравнивает цены в магазине, то есть нужно именно тем,
        // кто считает деньги.
        //
        // Планка проверена по КАЖДОМУ плагину, а не на глаз:
        //   mobile_scanner 5.2.3      minSdkVersion 21
        //   sqlite3_flutter_libs      minSdk = 21
        //   share_plus 10.1.4         minSdk 19
        //   geolocator_android        своего минимума не ставит
        // Двадцать первый — это потолок самого требовательного из них.
        // Опустить ниже нельзя: манифест не соберётся.
        minSdk = 21

        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // Подпись боевой сборки читается из android/key.properties, которого
    // в репозитории нет и не должно быть. Пока файла нет, release подписывается
    // отладочным ключом: `flutter run --release` работает, а вот в Play такой
    // артефакт не примут — и это правильно, случайно выложить нечем.
    signingConfigs {
        create("release") {
            val props = java.util.Properties()
            val file = rootProject.file("key.properties")
            if (file.exists()) {
                props.load(file.inputStream())
                storeFile = file(props.getProperty("storeFile"))
                storePassword = props.getProperty("storePassword")
                keyAlias = props.getProperty("keyAlias")
                keyPassword = props.getProperty("keyPassword")
            }
        }
    }

    buildTypes {
        release {
            signingConfig = if (rootProject.file("key.properties").exists()) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }

            // Минификация выключена намеренно. Выигрыш в размере на приложении
            // такого размера — единицы мегабайт, а R8 без правил обрезает то,
            // до чего дотягиваются только через рефлексию: drift-генерация,
            // json_serializable, плагины камеры. Включать её надо отдельной
            // задачей с проверкой на живом устройстве, а не «за компанию».
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
