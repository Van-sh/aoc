import java.nio.file.Path;

public class run {
   int day, task;

   static public void main(String[] args) {
      // WHY JAVA, JUST WHY
      if (args.length != 1) {
         run.usage();
      }
      var arg = args[0];
      if (!arg.startsWith("day")) {
         run.usage();
      }
      var dayAndTask = args[0].substring(3).split("-");
      if (dayAndTask.length != 2) {
         run.usage();
      }
      try {
         var day = Integer.parseInt(dayAndTask[0]);
         var task = Integer.parseInt(dayAndTask[1]);

         if (1 > day || day > 25 || 1 > task || task > 2) {
            run.usage();
         }

         var filePath = Path.of("src",
               String.format("day%02d", day),
               String.format("task%d", task),
               String.format("Task%d.java", task));

         new ProcessBuilder("java", filePath.toString())
               .inheritIO()
               .start()
               .waitFor();
      } catch (Exception e) {
         run.usage();
         e.printStackTrace();
         System.exit(1);
      }
   }

   static public void usage() {
      System.err.println("Usage: java run.java day{day_number}-{task_number}");
      System.exit(2);
   }
}
