plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services") // Pour Firebase (FlutterFire)
    id("dev.flutter.flutter-gradle-plugin") // À placer après android et kotlin
}

android {
    namespace = "com.example.budget_zise"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    defaultConfig {
        applicationId = "com.example.budget_zise"
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions { jvmTarget = "11" }

    splits {
        abi {
            reset()
            isEnable = true
            isUniversalApk = true
            include("armeabi-v7a", "arm64-v8a", "x86", "x86_64")
        }
    }

    signingConfigs {
        create("release") {
            if (project.hasProperty("MYAPP_UPLOAD_STORE_FILE")) {
                storeFile = file(project.property("MYAPP_UPLOAD_STORE_FILE") as String)
                storePassword = project.property("MYAPP_UPLOAD_STORE_PASSWORD") as String
                keyAlias = project.property("MYAPP_UPLOAD_KEY_ALIAS") as String
                keyPassword = project.property("MYAPP_UPLOAD_KEY_PASSWORD") as String
            }
        }
    }

    buildTypes {
        getByName("release") {
            isMinifyEnabled = true // Ajouté pour éviter le code shrink s’il n’est pas configuré
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter { source = "../.." }
    }
}

flutter { source = "../.." }
