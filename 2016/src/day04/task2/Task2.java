package day04.task2;

import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Duration;
import java.time.Instant;
import java.util.HashMap;

public class Task2 {
   Path path = Path.of("inputs", "day04", "input.txt");

   void task() {
      try (var lines = Files.lines(this.path)) {
         var result = lines.map((line) -> {
            return new Room(line);
         }).filter((room) -> {
            var roomName = room.decryptName();
            return roomName.equals("northpole object storage");
         }).findFirst().get().sectorId;

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

class Room {
   String encryptedName, checksum;
   int sectorId;
   HashMap<Character, Integer> frequencies;

   public Room(String line) {
      var lastDash = line.lastIndexOf("-");
      var sectorIdAndChecksum = line.substring(lastDash + 1).split("[\\[\\]]");

      this.encryptedName = line.substring(0, lastDash).replace("-", " ");
      this.sectorId = Integer.parseInt(sectorIdAndChecksum[0]);
      this.checksum = sectorIdAndChecksum[1];
      this.frequencies = new HashMap<>();
   }

   String decryptName() {
      var shift = this.sectorId % 26;
      var builder = new StringBuilder();

      for (var ch : this.encryptedName.toCharArray()) {
         if (ch == ' ') {
            builder.append(ch);
            continue;
         }
         var replaced = ch + shift;
         if (replaced > 'z') {
            replaced -= 26;
         }
         builder.append((char) replaced);
      }
      return builder.toString();
   }
}