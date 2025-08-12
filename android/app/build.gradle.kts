plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.chrisrenshaw.memory_support_app"
    compileSdk = 35

    defaultConfig {
        applicationId = "com.chrisrenshaw.memory_support_app"
        minSdk = 21
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
    }

    buildTypes {
        debug {
            signingConfig = signingConfigs.getByName("debug")
            isDebuggable = true
        }
        release {
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    lint {
        disable += "InvalidPackage"
        checkReleaseBuilds = false
    }
}

dependencies {
    implementation("androidx.multidex:multidex:2.0.1")
}

flutter {
    source = "../.."
}
