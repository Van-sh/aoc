package day13.task1;

import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Duration;
import java.time.Instant;
import java.util.ArrayDeque;
import java.util.HashSet;

public class Task1 {
   Path path = Path.of("inputs", "day13", "input.txt");
   Location target = new Location(31, 39);

   void task() {
      try {
         var favoriteNumber = Integer.parseInt(Files.readString(this.path).trim());
         var queue = new ArrayDeque<State>();
         var visited = new HashSet<Location>();
         var startingLocation = new Location(1, 1);
         queue.add(new State(0, startingLocation));
         visited.add(startingLocation);

         var result = 0;
         while (!queue.isEmpty()) {
            var state = queue.poll();
            var location = state.location();
            if (this.target.equals(location)) {
               result = state.steps();
               break;
            }

            for (var moveY = 1; moveY > -2; moveY -= 2) {
               var nextLocation = new Location(location.x(), location.y() + moveY);
               if (nextLocation.y() < 0 || nextLocation.isWall(favoriteNumber) || visited.contains(nextLocation)) {
                  continue;
               }
               queue.add(new State(state.steps() + 1, nextLocation));
               visited.add(nextLocation);
            }

            for (var moveX = 1; moveX > -2; moveX -= 2) {
               var nextLocation = new Location(location.x() + moveX, location.y());
               if (nextLocation.x() < 0 || nextLocation.isWall(favoriteNumber) || visited.contains(nextLocation)) {
                  continue;
               }
               queue.add(new State(state.steps() + 1, nextLocation));
               visited.add(nextLocation);
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

record Location(int x, int y) {
   boolean isWall(int favoriteNumber) {
      return (Integer.bitCount(
            this.x * this.x + 3 * this.x + 2 * this.x * this.y + this.y + this.y * this.y + favoriteNumber) & 1) == 1;

   }
}

record State(int steps, Location location) {
}