package day20.task1;

import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Duration;
import java.time.Instant;
import java.util.Comparator;
import java.util.PriorityQueue;

public class Task1 {
   Path path = Path.of("inputs", "day20", "input.txt");

   void task() {
      try {
         var lines = Files.readAllLines(this.path);

         var heap = new PriorityQueue<Range>(new Comparator<Range>() {
            @Override
            public int compare(Range arg0, Range arg1) {
               return Long.compare(arg0.start(), arg1.start());
            }
         });

         for (var line : lines) {
            var segments = line.split("-");

            heap.add(new Range(Integer.toUnsignedLong(Integer.parseUnsignedInt(segments[0])),
                  Integer.toUnsignedLong(Integer.parseUnsignedInt(segments[1]))));
         }

         var result = heap.poll().end() + 1;
         while (true) {
            var next = heap.poll();
            if (next.start() > result) {
               break;
            }
            result = Long.max(result, next.end() + 1);
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

record Range(long start, long end) {
}