package day21.task2;

import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Duration;
import java.time.Instant;

public class Task2 {
   Path path = Path.of("inputs", "day21", "input.txt");
   String start = "fbgdceah";

   void task() {
      try {
         var lines = Files.readAllLines(this.path).reversed();

         var sb = new StringBuilder();
         var result = this.start;
         for (var line : lines) {
            var segments = line.split(" ");
            if (line.startsWith("swap position")) {
               var x = Integer.parseInt(segments[2]);
               var y = Integer.parseInt(segments[5]);
               var idx1 = Integer.min(x, y);
               var idx2 = Integer.max(x, y);
               result = sb
                     .append(result.substring(0, idx1))
                     .append(result.charAt(idx2))
                     .append(result.substring(idx1 + 1, idx2))
                     .append(result.charAt(idx1))
                     .append(result.substring(idx2 + 1)).toString();
               sb.delete(0, sb.length());
               continue;
            }
            if (line.startsWith("swap letter")) {
               result = result.replace(segments[2], "#").replace(segments[5], segments[2]).replace("#", segments[5]);
               continue;
            }
            if (line.startsWith("reverse")) {
               var idx1 = Integer.parseInt(segments[2]);
               var idx2 = Integer.parseInt(segments[4]);
               var reversed = sb.append(result.substring(idx1, idx2 + 1)).reverse().toString();
               result = sb
                     .delete(0, sb.length())
                     .append(result.substring(0, idx1))
                     .append(reversed).append(result.substring(idx2 + 1))
                     .toString();
               sb.delete(0, sb.length());
               continue;
            }
            if (line.startsWith("rotate based")) {
               var idx = result.indexOf(segments[6]);

               var offset = 0;
               if ((idx & 1) == 1) {
                  offset = (idx + 1) / 2;
               } else {
                  offset = (idx + result.length() - (idx + result.length() - 2) % result.length() / 2 + 4)
                        % result.length();
               }
               result = sb
                     .append(result.substring(offset))
                     .append(result.substring(0, offset))
                     .toString();
               sb.delete(0, sb.length());
               continue;
            }
            if (line.startsWith("rotate")) {
               var offset = Integer.parseInt(segments[2]) % result.length();
               if (segments[1].equals("left")) {
                  offset = result.length() - offset;
               }

               result = sb
                     .append(result.substring(offset))
                     .append(result.substring(0, offset))
                     .toString();
               sb.delete(0, sb.length());
               continue;
            }
            if (line.startsWith("move")) {
               var from = Integer.parseInt(segments[2]);
               var to = Integer.parseInt(segments[5]);

               result = sb
                     .append(result.substring(0, to))
                     .append(result.substring(to + 1))
                     .insert(from, result.charAt(to))
                     .toString();
               sb.delete(0, sb.length());
               continue;
            }
            throw new RuntimeException("Unknown line: " + line);
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