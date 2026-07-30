package day19.task2;

import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Duration;
import java.time.Instant;
import java.util.ArrayDeque;

public class Task2 {
   Path path = Path.of("inputs", "day19", "input.txt");

   void task() {
      try {
         var numberOfElves = Integer.parseInt(Files.readString(this.path).trim());

         var queue = new ArrayDeque<Integer>();
         for (var i = 0; i < numberOfElves; i++) {
            queue.add((i + numberOfElves / 2) % numberOfElves + 1);
         }

         while (queue.size() > 1) {
            queue.poll();
            if ((queue.size() & 1) == 0) {
               queue.add(queue.poll());
            }
         }

         System.out.println(queue.poll());
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
