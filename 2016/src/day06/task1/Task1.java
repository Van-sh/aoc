package day06.task1;

import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Duration;
import java.time.Instant;
import java.util.ArrayList;
import java.util.HashMap;

public class Task1 {
   Path path = Path.of("inputs", "day06", "input.txt");

   void task() {
      try {
         var lines = Files.readAllLines(this.path);
         ArrayList<HashMap<Character, Integer>> counts = null;

         for (var line : lines) {
            if (counts == null) {
               counts = new ArrayList<>(line.length());
               for (var i = 0; i < line.length(); i++) {
                  counts.add(new HashMap<>());
               }
            }

            for (var i = 0; i < line.length(); i++) {
               var ch = line.charAt(i);
               counts.get(i).put(ch, counts.get(i).getOrDefault(ch, 0) + 1);
            }
         }

         var result = new StringBuilder();
         for (var i = 0; i < counts.size(); i++) {
            var max = 0;
            var maxChar = '\0';
            var entries = counts.get(i).entrySet();
            for (var entry : entries) {
               if (entry.getValue() > max) {
                  max = entry.getValue();
                  maxChar = entry.getKey();
               }
            }
            result.append(maxChar);
         }

         System.out.println(result.toString());
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
