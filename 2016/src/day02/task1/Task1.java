package day02.task1;

import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Duration;
import java.time.Instant;

public class Task1 {
   Path path = Path.of("inputs", "day02", "input.txt");
   int row = 1, col = 1;
   StringBuilder result = new StringBuilder();

   void task() {
      try (var lines = Files.lines(this.path)) {
         lines.forEach((line) -> {
            for (var ch : line.toCharArray()) {
               switch (ch) {
                  case 'U' -> this.row = Math.clamp(this.row - 1, 0, 2);
                  case 'D' -> this.row = Math.clamp(this.row + 1, 0, 2);
                  case 'L' -> this.col = Math.clamp(this.col - 1, 0, 2);
                  case 'R' -> this.col = Math.clamp(this.col + 1, 0, 2);
               }
            }
            this.result.append(3 * this.row + this.col + 1);
         });

         System.out.println(this.result.toString());
      } catch (Exception e) {
         e.printStackTrace();
         System.exit(1);
      }
   }

   public static void main(String[] args) {
      var start = Instant.now();

      new Task1().task();

      System.out.println("Done in " + Duration.between(start, Instant.now()).toString().substring(2).toLowerCase());
   }
}
