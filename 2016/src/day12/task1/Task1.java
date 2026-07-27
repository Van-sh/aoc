package day12.task1;

import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Duration;
import java.time.Instant;
import java.util.HashMap;

public class Task1 {
   Path path = Path.of("inputs", "day12", "input.txt");

   void task() {
      try (var lines = Files.lines(this.path)) {
         var registers = new HashMap<String, Integer>();
         registers.put("a", 0);
         registers.put("b", 0);
         registers.put("c", 0);
         registers.put("d", 0);

         var instructions = lines.map((line) -> line.split(" ")).toList();
         var programCounter = 0;

         while (programCounter < instructions.size()) {
            var instruction = instructions.get(programCounter);

            switch (instruction[0]) {
               case "cpy" -> {
                  var copiedValue = switch (instruction[1]) {
                     case "a", "b", "c", "d" -> registers.get(instruction[1]);
                     default -> Integer.parseInt(instruction[1]);
                  };
                  registers.put(instruction[2], copiedValue);
               }
               case "inc" -> registers.put(instruction[1], registers.get(instruction[1]) + 1);
               case "dec" -> registers.put(instruction[1], registers.get(instruction[1]) - 1);
               case "jnz" -> {
                  var value = switch (instruction[1]) {
                     case "a", "b", "c", "d" -> registers.get(instruction[1]);
                     default -> Integer.parseInt(instruction[1]);
                  };

                  if (value != 0) {
                     programCounter += Integer.parseInt(instruction[2]);
                     continue;
                  }
               }
               default -> throw new RuntimeException("unknown instruction: " + instruction[0]);
            }
            programCounter++;
         }
         System.out.println(registers.get("a"));
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
