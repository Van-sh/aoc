package day22.task2;

import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Duration;
import java.time.Instant;
import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.HashSet;

public class Task2 {
   Path path = Path.of("inputs", "day22", "input.txt");
   // column-major grid
   int minimumSteps = 1_000;

   void task() {
      try {
         var lines = Files.readAllLines(this.path);
         var disks = lines.subList(2, lines.size());
         var grid = new ArrayList<ArrayList<Integer>>();

         var emptyLocation = (Node) null;
         for (var disk : disks) {
            var segments = disk.replace("T", "").replace("x", "").replace("y", "").split(" +");

            var diskNameSegments = segments[0].split("-");

            var node = new Node(Integer.parseInt(diskNameSegments[1]), Integer.parseInt(diskNameSegments[2]));
            var newDisk = Integer.parseInt(segments[1]);

            if (Integer.parseInt(segments[2]) == 0) {
               emptyLocation = node;
            }
            if (node.y() == 0) {
               grid.add(new ArrayList<>());
            }
            grid.get(node.x()).add(newDisk);
         }

         var queue = new ArrayDeque<State>();
         var visited = new HashSet<VisitedKey>();
         queue.add(new State(0, emptyLocation, new Node(grid.size() - 1, 0)));
         visited.add(new VisitedKey(emptyLocation, new Node(grid.size(), 0)));

         var result = 0;
         queue: while (!queue.isEmpty()) {
            var state = queue.poll();

            emptyLocation = state.emptyLocation();

            var nextNodes = new ArrayList<Node>();
            for (var deltaX = -1; deltaX < 2; deltaX += 2) {
               if ((emptyLocation.x() + deltaX < 0 || emptyLocation.x() + deltaX >= grid.size())) {
                  continue;
               }
               nextNodes.add(new Node(emptyLocation.x() + deltaX, emptyLocation.y()));
            }
            for (var deltaY = -1; deltaY < 2; deltaY += 2) {
               if ((emptyLocation.y() + deltaY < 0 || emptyLocation.y() + deltaY >= grid.get(0).size())) {
                  continue;
               }
               nextNodes.add(new Node(emptyLocation.x(), emptyLocation.y() + deltaY));
            }

            for (var nextNode : nextNodes) {
               var checkDisk = grid.get(nextNode.x()).get(nextNode.y());
               if (checkDisk > 100) {
                  continue;
               }

               var newGoal = nextNode.equals(state.goal()) ? emptyLocation : state.goal();
               if (newGoal.x() == 0 && newGoal.y() == 0) {
                  result = state.steps() + 1;
                  break queue;
               }
               var key = new VisitedKey(nextNode, newGoal);
               if (visited.contains(key)) {
                  continue;
               }
               queue.add(new State(
                     state.steps() + 1,
                     nextNode,
                     newGoal));
               visited.add(key);
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

record State(int steps, Node emptyLocation, Node goal) {
}

record VisitedKey(Node emptyLocation, Node goal) {
}

record Node(int x, int y) {
}
