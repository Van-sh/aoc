package day07.task1;

import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Duration;
import java.time.Instant;

public class Task1 {
   Path path = Path.of("inputs", "day07", "input.txt");

   void task() {
      try (var lines = Files.lines(this.path)) {
         var result = lines.filter((line) -> {
            var isValid = false;
            var inHypernetSequence = false;
            for (var i = 0; i < line.length() - 3; i++) {
               var char1 = line.charAt(i);
               var char2 = line.charAt(i + 1);
               var char3 = line.charAt(i + 2);
               var char4 = line.charAt(i + 3);

               if (char1 == '[') {
                  inHypernetSequence = true;
                  continue;
               }
               if (char1 == ']') {
                  inHypernetSequence = false;
                  continue;
               }
               if (char1 == char4 && char2 == char3 && char1 != char2) {
                  if (inHypernetSequence) {
                     return false;
                  }
                  isValid = true;
               }
            }
            return isValid;
         }).count();

         System.out.println(result);
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