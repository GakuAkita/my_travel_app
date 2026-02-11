allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

// Source - https://stackoverflow.com/a/69390685
// Posted by JustinW
// Retrieved 2026-02-11, License - CC BY-SA 4.0

//tasks.register<Wrapper>(type: Wrapper) {
//    gradleVersion = "8.10"
//}
