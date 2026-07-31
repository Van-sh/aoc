package day21.task1;

import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Duration;
import java.time.Instant;

public class Task1 {
   Path path = Path.of("inputs", "day21", "input.txt");
   String start = "abcdefgh";

   void task() {
      try {
         var lines = Files.readAllLines(this.path);

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

               var offset = result.length() - ((1 + idx + (idx >= 4 ? 1 : 0)) % result.length());
               result = sb
                     .append(result.substring(offset))
                     .append(result.substring(0, offset))
                     .toString();
               sb.delete(0, sb.length());
               continue;
            }
            if (line.startsWith("rotate")) {
               var offset = Integer.parseInt(segments[2]) % result.length();
               if (segments[1].equals("right")) {
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
                     .append(result.substring(0, from))
                     .append(result.substring(from + 1))
                     .insert(to, result.charAt(from))
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

      new Task1().task();

      System.out.println("Done in " + Duration.between(start, Instant.now()).toString().substring(2).toLowerCase());
   }
}
