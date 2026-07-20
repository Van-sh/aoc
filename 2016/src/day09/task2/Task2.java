package day09.task2;

import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Duration;
import java.time.Instant;

public class Task2 {
   Path path = Path.of("inputs", "day09", "input.txt");

   void task() {
      try {
         var input = Files.readString(this.path).trim();

         System.out.println(Decompressor.decompress(input));
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

class Decompressor {
   static long decompress(String input) {
      var length = (long) 0;

      for (int i = 0; i < input.length(); i++) {
         var ch = input.charAt(i);
         if (ch == '(') {
            var closeIndex = input.indexOf(')', i + 1);
            var dimensions = input.substring(i + 1, closeIndex).split("x");

            var substringSize = Integer.parseInt(dimensions[0]);
            var repetitions = Integer.parseInt(dimensions[1]);

            var subLength = Decompressor.decompress(input.substring(closeIndex + 1,
                  closeIndex + substringSize + 1));
            length += (subLength * repetitions);

            i = closeIndex + substringSize;
            continue;
         }

         length += 1;
      }

      return length;
   }
}