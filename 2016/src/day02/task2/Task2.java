package day02.task2;

import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Duration;
import java.time.Instant;

public class Task2 {
   Path path = Path.of("inputs", "day02", "input.txt");
   int row = 2, col = 0;
   StringBuilder result = new StringBuilder();

   void task() {
      try (var lines = Files.lines(this.path)) {
         lines.forEach((line) -> {
            for (var ch : line.toCharArray()) {
               switch (ch) {
                  case 'U' -> {
                     var bounds = this.getVerticalBounds();
                     this.row = Math.clamp(this.row - 1, bounds.min(), bounds.max());
                  }
                  case 'D' -> {
                     var bounds = this.getVerticalBounds();
                     this.row = Math.clamp(this.row + 1, bounds.min(), bounds.max());
                  }
                  case 'L' -> {
                     var bounds = this.getHorizontalBounds();
                     this.col = Math.clamp(this.col - 1, bounds.min(), bounds.max());
                  }
                  case 'R' -> {
                     var bounds = this.getHorizontalBounds();
                     this.col = Math.clamp(this.col + 1, bounds.min(), bounds.max());
                  }
               }
            }
            this.pressCurrentKey();
         });

         System.out.println(this.result.toString());
      } catch (Exception e) {
         System.err.println(e);
         System.exit(1);
      }
   }

   void pressCurrentKey() {
      result.append(Integer.toString(this.col + switch (this.row) {
         case 0 -> -1;
         case 1 -> 1;
         case 2 -> 5;
         case 3 -> 9;
         case 4 -> 11;
         default -> throw new RuntimeException("dead");
      }, 14).toUpperCase());
   }

   Bounds getHorizontalBounds() {
      return this.row == 2 ? new Bounds(0, 4) : (this.row & 1) == 1 ? new Bounds(1, 3) : new Bounds(2, 2);
   }

   Bounds getVerticalBounds() {
      return this.col == 2 ? new Bounds(0, 4) : (this.col & 1) == 1 ? new Bounds(1, 3) : new Bounds(2, 2);
   }

   public static void main(String[] args) {
      var start = Instant.now();

      new Task2().task();

      System.out.println("Done in " + Duration.between(start, Instant.now()).toString().substring(2).toLowerCase());
   }
}

record Bounds(int min, int max) {
}
