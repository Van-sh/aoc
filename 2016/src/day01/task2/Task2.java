package day01.task2;

import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Duration;
import java.time.Instant;
import java.util.HashSet;

public class Task2 {
   Path path = Path.of("inputs", "day01", "input.txt");
   Direction direction = Direction.North;
   HashSet<Vector2D> visited = new HashSet<>();
   Vector2D location = new Vector2D(0, 0);

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
               default -> throw new RuntimeException("Invalid Direction");
            };
            if (this.moveAndCheckForDestination(distance)) {
               break;
            }
         }

         System.out.println(this.location.getDistanceFromOrigin());
      } catch (Exception e) {
         System.err.println(e);
         System.exit(1);
      }
   }

   boolean moveAndCheckForDestination(int distance) {
      for (int i = 0; i < distance; i++) {
         switch (this.direction) {
            case North -> this.location = new Vector2D(this.location.x(), this.location.y() - 1);
            case South -> this.location = new Vector2D(this.location.x(), this.location.y() + 1);
            case East -> this.location = new Vector2D(this.location.x() + 1, this.location.y());
            case West -> this.location = new Vector2D(this.location.x() - 1, this.location.y());
         }

         if (this.visited.contains(this.location)) {
            return true;
         }
         this.visited.add(this.location);
      }
      return false;
   }

   public static void main(String[] args) {
      var start = Instant.now();

      new Task2().task();

      System.out.println("Done in " + Duration.between(start, Instant.now()).toString().substring(2).toLowerCase());
   }
}

record Vector2D(int x, int y) {
   int getDistanceFromOrigin() {
      return Math.abs(this.x) + Math.abs(this.y);
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
