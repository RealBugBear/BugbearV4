// File: android/build.gradle.kts

buildscript {
    // Define Kotlin plugin version in Kotlin DSL
    val kotlinVersion = "1.8.22"

    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:8.1.0")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlinVersion")
        classpath("com.google.gms:google-services:4.3.15")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Redirect all module outputs under the single top‐level build/ folder
rootProject.buildDir = file("../build")
subprojects {
    project.buildDir = rootProject.buildDir.resolve(project.name)
}
