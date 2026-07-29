package day17.task1;

import java.math.BigInteger;
import java.nio.file.Files;
import java.nio.file.Path;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.time.Duration;
import java.time.Instant;
import java.util.ArrayDeque;

public class Task1 {
   Path path = Path.of("inputs", "day17", "input.txt");

   void task() {
      try {
         var passcode = Files.readString(this.path).trim();

         var queue = new ArrayDeque<State>();
         queue.add(new State("", 0, 0));

         var result = "";
         while (!queue.isEmpty()) {
            var state = queue.poll();
            var x = state.x();
            var y = state.y();
            if (x == 3 && y == 3) {
               result = state.path();
               break;
            }

            var doors = state.getUnlockedDoors(passcode);

            for (var i = 0; i < 4; i++) {
               if (!doors[i]) {
                  continue;
               }

               var nextState = switch (i) {
                  case Direction.up -> (y - 1 < 0) ? null : new State(state.path() + "U", x, y - 1);
                  case Direction.down -> (y + 1 >= 4) ? null : new State(state.path() + "D", x, y + 1);
                  case Direction.left -> (x - 1 < 0) ? null : new State(state.path() + "L", x - 1, y);
                  case Direction.right -> (x + 1 >= 4) ? null : new State(state.path() + "R", x + 1, y);
                  default -> {
                     throw new RuntimeException("Unreachable: " + i);
                  }
               };

               if (nextState == null) {
                  continue;
               }
               queue.add(nextState);
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

record State(String path, int x, int y) {
   boolean[] getUnlockedDoors(String passcode) throws NoSuchAlgorithmException {
      var md5 = MessageDigest.getInstance("MD5");
      var hash = new BigInteger(1, md5.digest((passcode + this.path).getBytes())).toString(16);
      hash = "0".repeat(32 - hash.length()) + hash;

      var result = new boolean[4];
      for (var i = 0; i < 4; i++) {
         result[i] = switch (hash.charAt(i)) {
            case 'b', 'c', 'd', 'e', 'f' -> true;
            default -> false;
         };
      }

      return result;
   }
}

final class Direction {
   static final int up = 0;
   static final int down = 1;
   static final int left = 2;
   static final int right = 3;
}