package day18.task2;

import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Duration;
import java.time.Instant;
import java.util.ArrayList;

public class Task2 {
   Path path = Path.of("inputs", "day18", "input.txt");
   int rows = 400000;

   void task() {
      try {
         var input = Files.readString(this.path).trim();

         var grid = new ArrayList<ArrayList<Boolean>>();
         var firstRow = new ArrayList<Boolean>();
         for (var ch : input.toCharArray()) {
            firstRow.add(switch (ch) {
               case '.' -> true;
               case '^' -> false;
               default ->
                  throw new RuntimeException(new StringBuilder().append("Unknown character: ").append(ch).toString());
            });
         }
         grid.add(firstRow);

         while (grid.size() < this.rows) {
            var previousRow = grid.getLast();
            var row = new ArrayList<Boolean>();

            for (var i = 0; i < previousRow.size(); i++) {
               var left = i == 0 ? true : previousRow.get(i - 1);
               var right = i == previousRow.size() - 1 ? true : previousRow.get(i + 1);

               row.add(!(left ^ right));
            }
            grid.add(row);
         }
         var result = grid
               .stream()
               .map((row) -> row
                     .stream()
                     .map((cell) -> cell ? 1 : 0)
                     .reduce(0, (var acc, var val) -> acc + val))
               .reduce(0, (var acc, var val) -> acc + val);

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
