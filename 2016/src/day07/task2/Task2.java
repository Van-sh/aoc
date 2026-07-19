package day07.task2;

import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Duration;
import java.time.Instant;
import java.util.HashSet;

public class Task2 {
   Path path = Path.of("inputs", "day07", "input.txt");

   void task() {
      try (var lines = Files.lines(this.path)) {
         var result = lines.filter((line) -> {
            var subnetMatches = new HashSet<String>();
            var hypernetMatches = new HashSet<String>();
            var isValid = false;
            var inHypernetSequence = false;
            for (var i = 0; i < line.length() - 2; i++) {
               var sb = new StringBuilder();
               var char1 = line.charAt(i);
               var char2 = line.charAt(i + 1);
               var char3 = line.charAt(i + 2);

               if (char1 == '[') {
                  inHypernetSequence = true;
                  continue;
               }
               if (char1 == ']') {
                  inHypernetSequence = false;
                  continue;
               }
               if (char1 == char3 && char1 != char2) {
                  var check = sb.append(char2).append(char1).toString();
                  var match = sb.delete(0, 2).append(char1).append(char2).toString();
                  if (inHypernetSequence) {
                     if (subnetMatches.contains(check)) {
                        return true;
                     }
                     hypernetMatches.add(match);
                  } else {
                     if (hypernetMatches.contains(check)) {
                        return true;
                     }
                     subnetMatches.add(match);
                  }
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

      new Task2().task();

      System.out.println("Done in " + Duration.between(start, Instant.now()).toString().substring(2).toLowerCase());
   }
}