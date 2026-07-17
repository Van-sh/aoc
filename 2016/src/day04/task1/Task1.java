package day04.task1;

import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Duration;
import java.time.Instant;
import java.util.ArrayList;
import java.util.HashMap;

public class Task1 {
   Path path = Path.of("inputs", "day04", "input.txt");

   void task() {
      try (var lines = Files.lines(this.path)) {
         var result = lines.map((line) -> {
            var room = new Room(line);
            if (room.isReal()) {
               return room.sectorId;
            }
            return 0;
         }).reduce(Integer::sum).get();

         System.out.println(result);
      } catch (Exception e) {
         System.err.println(e);
         System.exit(1);
      }
   }

   public static void main(String[] args) {
      var start = Instant.now();

      new Task1().task();

      System.out.println("Done in " + Duration.between(start, Instant.now()).toString().substring(2).toLowerCase());
   }
}

class Room {
   String encryptedName, checksum;
   int sectorId;
   HashMap<Character, Integer> frequencies;

   public Room(String line) {
      var lastDash = line.lastIndexOf("-");
      var sectorIdAndChecksum = line.substring(lastDash + 1).split("[\\[\\]]");

      this.encryptedName = String.join("", line.substring(0, lastDash).split("-"));
      this.sectorId = Integer.parseInt(sectorIdAndChecksum[0]);
      this.checksum = sectorIdAndChecksum[1];
      this.frequencies = new HashMap<>();
   }

   boolean isReal() {
      for (var ch : this.encryptedName.toCharArray()) {
         this.frequencies.put(ch, this.frequencies.getOrDefault(ch, 0) + 1);
      }

      var entries = new ArrayList<>(this.frequencies.entrySet());
      entries.sort((a, b) -> {
         var aCount = a.getValue();
         var bCount = b.getValue();

         if (aCount != bCount) {
            return bCount - aCount;
         } else {
            return (int) a.getKey() - b.getKey();
         }
      });

      var check = new StringBuilder();
      entries.subList(0, 5).forEach((entry) -> check.append(entry.getKey()));

      return check.toString().equals(this.checksum);
   }
}