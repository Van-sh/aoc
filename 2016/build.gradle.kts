plugins {
    java
}

sourceSets {
    main {
        java.srcDirs("src")
    }
}

fun createAocTask(dayDir: String, taskDir: String) {
    val dayNum = dayDir.removePrefix("day").trimStart('0').ifEmpty { "0" }
    val taskSuffix = Regex("\\d+$").find(taskDir)?.value ?: ""
    val gradleTaskName = if (taskSuffix.isEmpty()) "day$dayNum" else "day$dayNum-$taskSuffix"
    val className = taskDir.replaceFirstChar { it.uppercase() } // task1 -> Task1, task -> Task

    tasks.register<JavaExec>(gradleTaskName) {
        group = "run"
        description = "Run $dayDir $taskDir"
        classpath = sourceSets["main"].runtimeClasspath
        mainClass.set("$dayDir.$taskDir.$className")
    }
}

createAocTask("day01", "task1")
createAocTask("day01", "task2")
createAocTask("day02", "task1")
createAocTask("day02", "task2")
