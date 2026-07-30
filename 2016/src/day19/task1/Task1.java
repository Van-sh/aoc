package day19.task1;

import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Duration;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Collections;

public class Task1 {
   Path path = Path.of("inputs", "day19", "input.txt");

   void task() {
      try {
         var numberOfElves = Integer.parseInt(Files.readString(this.path).trim());

         var elves = new ArrayList<Integer>();
         for (var i = 1; i <= numberOfElves; i++) {
            elves.add(i);
         }

         var keepOffset = 0;
         while (elves.size() > 1) {
            var isOdd = (elves.size() & 1) == 1;
            var partition = elves.size() / 2 + ((isOdd && keepOffset == 0) ? 1 : 0);

            for (var i = 0; i < partition; i++) {
               Collections.swap(elves, i, 2 * i + keepOffset);
            }

            elves.subList(partition, elves.size()).clear();
            if (isOdd) {
               keepOffset = (keepOffset + 1) % 2;
            }
         }

         System.out.println(elves.get(0));
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
