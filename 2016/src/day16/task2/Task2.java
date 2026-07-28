package day16.task2;

import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Duration;
import java.time.Instant;

public class Task2 {
   Path path = Path.of("inputs", "day16", "input.txt");
   int diskSize = 35651584;

   void task() {
      try {
         var value = Files.readString(this.path).trim();

         while (value.length() < this.diskSize) {
            value = new StringBuilder()
                  .append(value)
                  .append(0)
                  .append(new StringBuilder()
                        .append(value)
                        .reverse()
                        .toString()
                        .replace("0", "#").replace("1", "0").replace("#", "1"))
                  .toString();
         }

         var result = value.substring(0, this.diskSize);

         while ((result.length() & 1) == 0) {
            var sb = new StringBuilder();
            for (var i = 0; i < result.length(); i += 2) {
               sb.append(result.charAt(i) == result.charAt(i + 1) ? "1" : "0");
            }
            result = sb.toString();
         }

         System.out.println(result);
      } catch (Exception e) {
         e.printStackTrace();
         System.exit(1);
      }
   }

   public static void main(String[] args) {
      var start = Instant.now();

      new Task2().task();

      System.out.println("Done in " + Duration.between(start, Instant.now()).toString().substring(2).toLowerCase());
   }
}
