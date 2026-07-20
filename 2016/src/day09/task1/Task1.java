package day09.task1;

import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Duration;
import java.time.Instant;

public class Task1 {
   Path path = Path.of("inputs", "day09", "input.txt");

   void task() {
      try {
         var input = Files.readString(this.path).trim();

         System.out.println(Decompressor.decompress(input).length());
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

class Decompressor {
   static String decompress(String input) {
      var sb = new StringBuilder();
      for (int i = 0; i < input.length(); i++) {
         var ch = input.charAt(i);
         if (ch == '(') {
            var closeIndex = input.indexOf(')', i + 1);
            var dimensions = input.substring(i + 1, closeIndex).split("x");

            var length = Integer.parseInt(dimensions[0]);
            var repetitions = Integer.parseInt(dimensions[1]);
            sb.append(input.substring(closeIndex + 1, closeIndex + length + 1).repeat(repetitions));

            i = closeIndex + length;
            continue;
         }

         sb.append(ch);
      }

      return sb.toString();
   }
}