plugins {
    java
}

sourceSets {
    main {
        java.srcDirs("src")
    }
}

fun createTask(dayDir: String, taskDir: String) {
    val dayNum = dayDir.removePrefix("day").trimStart('0').ifEmpty { "0" }
    val taskSuffix = Regex("\\d+$").find(taskDir)?.value ?: ""
    val gradleTaskName = if (taskSuffix.isEmpty()) "day$dayNum" else "day$dayNum-$taskSuffix"
    val className = taskDir.replaceFirstChar { it.uppercase() } // task1 -> Task1, task -> Task

    tasks.register<JavaExec>(gradleTaskName) {
        group = "run"
        description = "Run $dayDir.$taskDir.$className"
        classpath = sourceSets["main"].runtimeClasspath
        mainClass.set("$dayDir.$taskDir.$className")
    }
}

createTask("day01", "task1")
createTask("day01", "task2")
