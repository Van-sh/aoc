package day01.task1;

import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Duration;
import java.time.Instant;

public class Task1 {
   Path path = Path.of("inputs", "day01", "input.txt");
   Direction direction = Direction.North;
   int x, y;

   void task() {
      try {
         var input = Files.readString(this.path).trim().split(", ");
         for (var instruction : input) {
            var turnDirection = instruction.charAt(0);
            var distanceString = instruction.substring(1, instruction.length());
            var distance = Integer.parseInt(distanceString);

            this.direction = switch (turnDirection) {
               case 'R' -> this.direction.turnRight();
               case 'L' -> this.direction.turnLeft();
               default -> throw new RuntimeException("Invalid direction");
            };
            move(distance);
         }

         System.out.println(Math.abs(this.x) + Math.abs(this.y));
      } catch (Exception e) {
         System.err.println(e);
         System.exit(1);
      }
   }

   void move(int distance) {
      switch (this.direction) {
         case North -> this.y -= distance;
         case South -> this.y += distance;
         case East -> this.x += distance;
         case West -> this.x -= distance;
      }
   }

   public static void main(String[] args) {
      var start = Instant.now();

      new Task1().task();

      System.out.println("Done in " + Duration.between(start, Instant.now()).toString().substring(2).toLowerCase());
   }
}

enum Direction {
   North,
   South,
   East,
   West;

   Direction turnRight() {
      return switch (this) {
         case North -> East;
         case South -> West;
         case East -> South;
         case West -> North;
      };
   }

   Direction turnLeft() {
      return switch (this) {
         case North -> West;
         case South -> East;
         case East -> North;
         case West -> South;
      };
   }
}
