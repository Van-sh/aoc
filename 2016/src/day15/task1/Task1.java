package day15.task1;

import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Duration;
import java.time.Instant;
import java.util.Arrays;

public class Task1 {
   Path path = Path.of("inputs", "day15", "input.txt");

   void task() {
      try (var lines = Files.lines(this.path)) {
         var discs = lines.map((line) -> Arrays.stream(line
               .replace(" positions; at time=0, it is at position", "")
               .replace(".", "")
               .replaceAll(".*has ", "")
               .split(" "))
               .map((e) -> Integer.parseInt(e)).toList()).toList();

         var result = 0;
         timer: for (result = 0; true; result++) {
            for (var i = 0; i < discs.size(); i++) {
               var positions = discs.get(i).get(0);
               var start = discs.get(i).get(1);

               var currentPosition = (start + result + 1 + i) % positions;

               if (currentPosition != 0) {
                  continue timer;
               }
            }
            break;
         }

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
