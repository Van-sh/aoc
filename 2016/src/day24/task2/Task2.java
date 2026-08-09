package day24.task2;

import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Duration;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashSet;
import java.util.PriorityQueue;

public class Task2 {
   Path path = Path.of("inputs", "day24", "input.txt");

   void task() {
      try (var lines = Files.lines(this.path)) {
         var grid = lines
               .map((line) -> line
                     .chars()
                     .mapToObj((i) -> (char) i)
                     .map((ch) -> switch (ch) {
                        case '#' -> -2;
                        case '.' -> -1;
                        default -> ch - '0';
                     }).toList())
               .toList();

         var maxRelevantLocation = 0;
         var startX = 0;
         var startY = 0;
         for (var y = 0; y < grid.size(); y++) {
            var row = grid.get(y);
            for (var x = 0; x < row.size(); x++) {
               var cell = row.get(x);
               maxRelevantLocation = Integer.max(maxRelevantLocation, cell);

               if (cell == 0) {
                  startX = x;
                  startY = y;
               }
            }
         }

         var resultMask = 0;
         for (var i = 0; i < maxRelevantLocation; i++) {
            resultMask |= (1 << i);
         }

         var queue = new PriorityQueue<State>(
               new Comparator<State>() {
                  @Override
                  public int compare(State arg0, State arg1) {
                     if (arg0.numberOfSteps() != arg1.numberOfSteps()) {
                        return Integer.compare(arg0.numberOfSteps(), arg1.numberOfSteps());
                     }
                     return Integer.compare(Integer.bitCount(arg1.collected()), Integer.bitCount(arg0.collected()));
                  }
               });
         var visited = new HashSet<Visited>();

         var startingState = new State(0, 0, startX, startY);
         queue.add(startingState);
         visited.add(startingState.getVisitedKey());

         var result = 0;
         outer: while (!queue.isEmpty()) {
            var state = queue.poll();

            var numberOfSteps = state.numberOfSteps();
            var collected = state.collected();
            var x = state.x();
            var y = state.y();

            var nextStates = new ArrayList<State>(4);

            for (var deltaY = -1; deltaY < 2; deltaY += 2) {
               var newY = y + deltaY;
               if (newY < 0 || newY > grid.size()) {
                  continue;
               }
               var cell = grid.get(newY).get(x);
               if (cell < -1) {
                  continue;
               }

               var newCollected = collected;
               if (cell > 0) {
                  newCollected |= (1 << (cell - 1));
               }

               nextStates.add(new State(numberOfSteps + 1, newCollected, x, newY));
            }

            for (var deltaX = -1; deltaX < 2; deltaX += 2) {
               var newX = x + deltaX;
               if (newX < 0 || newX > grid.get(0).size()) {
                  continue;
               }
               var cell = grid.get(y).get(newX);
               if (cell < -1) {
                  continue;
               }

               var newCollected = collected;
               if (cell > 0) {
                  newCollected |= (1 << (cell - 1));
               }

               nextStates.add(new State(numberOfSteps + 1, newCollected, newX, y));
            }

            for (var nextState : nextStates) {
               if (visited.contains(nextState.getVisitedKey())) {
                  continue;
               }
               if ((nextState.collected() ^ resultMask) == 0 && nextState.x() == startX && nextState.y() == startY) {
                  result = numberOfSteps + 1;
                  break outer;
               }

               queue.add(nextState);
               visited.add(nextState.getVisitedKey());
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

      new Task2().task();

      System.out.println("Done in " + Duration.between(start, Instant.now()).toString().substring(2).toLowerCase());
   }
}

record State(int numberOfSteps, int collected, int x, int y) {
   Visited getVisitedKey() {
      return new Visited(this.collected, this.x, this.y);
   }
}

record Visited(int collected, int x, int y) {
}