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

      try {
         var day = 0;
         var task = "";

         switch (dayAndTask.length) {
            case 1 -> {
               day = Integer.parseInt(dayAndTask[0]);
               if (day != 25) {
                  run.usage();
               }
            }
            case 2 -> {
               day = Integer.parseInt(dayAndTask[0]);
               if (1 > day || day > 24) {
                  run.usage();
               }
               task = dayAndTask[1];
               if (!task.equals("1") && !task.equals("2")) {
                  run.usage();
               }
            }
            default -> run.usage();
         }

         var filePath = Path.of("src",
               String.format("day%02d", day),
               String.format("task%s", task),
               String.format("Task%s.java", task));

         new ProcessBuilder("java", filePath.toString())
               .inheritIO()
               .start()
               .waitFor();
      } catch (Exception e) {
         run.usage(false);
         e.printStackTrace();
         System.exit(1);
      }
   }

   static public void usage() {
      usage(true);
   }

   static public void usage(boolean exit) {
      System.err.println("Usage: java run.java day{day_number}-{task_number}");
      if (exit)
         System.exit(2);
   }
}
