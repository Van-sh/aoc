package day03.task2;

import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Duration;
import java.time.Instant;

public class Task2 {
   Path path = Path.of("inputs", "day03", "input.txt");

   void task() {
      try {
         var result = 0;
         var lines = Files.readAllLines(this.path);
         for (var i = 0; i < lines.size(); i += 3) {
            var aSides = lines.get(i).trim().split(" +");
            var bSides = lines.get(i + 1).trim().split(" +");
            var cSides = lines.get(i + 2).trim().split(" +");

            for (var j = 0; j < 3; j++) {
               if (Triangle.isValid(aSides[j], bSides[j], cSides[j])) {
                  result += 1;
               }
            }
         }

         System.out.println(result);
      } catch (Exception e) {
         System.err.println(e);
         System.exit(1);
      }
   }

   public static void main(String[] args) {
      var start = Instant.now();

      new Task2().task();

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