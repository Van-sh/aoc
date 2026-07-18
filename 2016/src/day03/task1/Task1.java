package day03.task1;

import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Duration;
import java.time.Instant;

public class Task1 {
   Path path = Path.of("inputs", "day03", "input.txt");

   void task() {
      try (var lines = Files.lines(this.path)) {
         var result = lines.filter((line) -> {
            var sides = line.trim().split(" +");

            return Triangle.isValid(sides[0], sides[1], sides[2]);
         }).count();

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

class Triangle {
   static boolean isValid(String a, String b, String c) {
      var sideA = Integer.parseInt(a);
      var sideB = Integer.parseInt(b);
      var sideC = Integer.parseInt(c);
      return (sideA + sideB) > sideC && (sideB + sideC) > sideA && (sideC + sideA) > sideB;
   }
}