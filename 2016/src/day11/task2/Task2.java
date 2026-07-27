package day11.task2;

import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Duration;
import java.time.Instant;
import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;

public class Task2 {
   Path path = Path.of("inputs", "day11", "input.txt");
   ArrayDeque<State> queue = new ArrayDeque<>();
   HashSet<Visited> visited = new HashSet<>();

   void task() {
      try {
         var lines = Arrays.asList(Files.readString(this.path)
               .replace(".", "").replace(",", "")
               .replace("and ", "").replace("-compatible", "")
               .split("\n"));

         var indices = new HashMap<String, Integer>();
         var parsedComponents = new ArrayList<Integer>();
         parsedComponents.add(0b00010001);
         parsedComponents.add(0b00010001);
         for (var floor = 0; floor < lines.size(); floor++) {
            var line = lines.get(floor);

            if (line.contains("nothing relevant")) {
               continue;
            }

            var tmpSegments = line.split(" a ");
            var segments = Arrays.asList(Arrays.copyOfRange(tmpSegments, 1, tmpSegments.length));

            for (var segment : segments) {
               var components = segment.split(" ");
               var element = components[0];
               if (indices.get(element) == null) {
                  indices.put(element, parsedComponents.size());
                  parsedComponents.add(0);
               }

               var idx = indices.get(components[0]);
               switch (components[1]) {
                  case "microchip" -> parsedComponents.set(idx, (parsedComponents.get(idx) | 1 << (4 + floor)));
                  case "generator" -> parsedComponents.set(idx, (parsedComponents.get(idx) | 1 << floor));
                  default -> throw new RuntimeException("Unknown segment: " + segment);
               }
            }
         }
         var startingState = new State(0, 0, parsedComponents);

         this.queue.add(startingState);
         this.visited.add(new Visited(startingState.floor(), startingState.components()));

         var result = this.solve();
         System.out.println(result);
      } catch (Exception e) {
         e.printStackTrace();
         System.exit(1);
      }
   }

   int solve() {
      while (!this.queue.isEmpty()) {
         var state = this.queue.poll();
         var floor = state.floor();
         var components = state.components();

         var componentsOnThisFloor = new ArrayList<Move>();
         for (var i = 0; i < components.size(); i++) {
            var component = components.get(i);
            if ((component & 1 << floor) != 0) {
               componentsOnThisFloor.add(new Move(i, false));
            }
            if ((component & 1 << (4 + floor)) != 0) {
               componentsOnThisFloor.add(new Move(i, true));
            }
         }

         var moveCombinations = new ArrayList<>(componentsOnThisFloor
               .stream()
               .map((component) -> Arrays.asList(component)).toList());

         for (var i = 0; i < componentsOnThisFloor.size() - 1; i++) {
            for (var j = i + 1; j < componentsOnThisFloor.size(); j++) {
               moveCombinations.add(Arrays.asList(componentsOnThisFloor.get(i), componentsOnThisFloor.get(j)));
            }
         }

         // 1 goes up, -1 goes down
         for (var floorChange = 1; floorChange > -2; floorChange -= 2) {
            if (floor + floorChange < 0 || floor + floorChange > 3) {
               continue;
            }
            for (var moveList : moveCombinations) {
               var newComponents = new ArrayList<>(components);
               for (var move : moveList) {
                  var pair = newComponents.get(move.index());
                  var replacement = 0;

                  if (move.isMicrochip()) {
                     var microchip = pair & Masks.microchip;
                     var newMicrochip = (floorChange == 1) ? microchip << 1 : microchip >> 1;

                     replacement = newMicrochip | (pair & Masks.generator);
                  } else {
                     var generator = pair & Masks.generator;
                     var newGenerator = (floorChange == 1) ? generator << 1 : generator >> 1;

                     replacement = newGenerator | (pair & Masks.microchip);
                  }
                  newComponents.set(move.index(), replacement);
               }
               var newState = new State(state.numberOfTurns() + 1, floor + floorChange, newComponents);
               if (newState.isDone()) {
                  return state.numberOfTurns() + 1;
               }
               var visited = new Visited(newState.floor(), newState.components());

               if (newState.isValid() && !this.visited.contains(visited)) {
                  this.queue.add(newState);
                  this.visited.add(visited);
               }
            }
         }
      }
      throw new RuntimeException("Ran out of moves");
   }

   public static void main(String[] args) {
      var start = Instant.now();

      new Task2().task();

      System.out.println("Done in " + Duration.between(start, Instant.now()).toString().substring(2).toLowerCase());
   }
}

record State(int numberOfTurns, int floor, ArrayList<Integer> components) {
   boolean isValid() {
      for (var floor = 0; floor < 4; floor++) {
         var floorHasGenerator = false;
         for (var pair : this.components) {
            if ((pair & 1 << floor) != 0) {
               floorHasGenerator = true;
               break;
            }
         }

         if (!floorHasGenerator) {
            continue;
         }

         for (var pair : this.components) {
            if ((pair & (1 << 4 + floor)) != 0 && (pair & 1 << floor) == 0) {
               return false;
            }
         }
      }
      return true;
   }

   boolean isDone() {
      return this.components.stream().allMatch((pair) -> pair == 0b10001000);
   }
}

record Visited(int floor, ArrayList<Integer> components) {
}

record Move(int index, boolean isMicrochip) {
}

final class Masks {
   static final int generator = 0b0000_1111;
   static final int microchip = 0b1111_0000;
}
