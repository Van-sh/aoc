package day22.task1;

import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Duration;
import java.time.Instant;

public class Task1 {
   Path path = Path.of("inputs", "day22", "input.txt");

   void task() {
      try (var lines = Files.lines(this.path)) {
         var disks = lines.skip(2).map((line) -> {
            var segments = line.replace("T", "").split(" +");

            return new Disk(Integer.parseInt(segments[2]), Integer.parseInt(segments[3]));
         }).toList();

         var result = 0;
         for (var i = 0; i < disks.size() - 1; i++) {
            for (var j = i + 1; j < disks.size(); j++) {
               var diskA = disks.get(i);
               var diskB = disks.get(j);

               if (diskA.used() > 0 && diskA.used() <= diskB.avail()) {
                  result++;
               }
               if (diskB.used() > 0 && diskB.used() <= diskA.avail()) {
                  result++;
               }
            }
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

record Disk(int used, int avail) {
}