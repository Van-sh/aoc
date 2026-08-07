package day25.task;

import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Duration;
import java.time.Instant;
import java.util.ArrayList;
import java.util.HashMap;

public class Task {
   Path path = Path.of("inputs", "day25", "input.txt");

   void task() {
      try (var lines = Files.lines(this.path)) {
         var initialInstructions = lines.map((line) -> line.split(" ")).toList();
         var aValue = 0;
         outer: for (aValue = 0; true; aValue++) {
            var registers = new HashMap<String, Integer>();
            registers.put("a", aValue);
            registers.put("b", 0);
            registers.put("c", 0);
            registers.put("d", 0);

            var instructions = new ArrayList<>(initialInstructions);
            var output = new ArrayList<Integer>(1_000);
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
                        programCounter += switch (instruction[2]) {
                           case "a", "b", "c", "d" -> registers.get(instruction[2]);
                           default -> Integer.parseInt(instruction[2]);
                        };
                        continue;
                     }
                  }
                  case "tgl" -> {
                     var idx = programCounter + switch (instruction[1]) {
                        case "a", "b", "c", "d" -> registers.get(instruction[1]);
                        default -> Integer.parseInt(instruction[1]);
                     };
                     if (!(idx < 0 || idx >= instructions.size())) {
                        var instructionToToggle = instructions.get(idx);

                        instructionToToggle[0] = switch (instructionToToggle[0]) {
                           case "inc" -> "dec";
                           case "dec", "tgl" -> "inc";
                           case "jnz" -> "cpy";
                           case "cpy" -> "jnz";
                           default -> throw new RuntimeException("Unreachable");
                        };
                     }
                  }
                  case "out" -> {
                     var value = registers.get(instruction[1]);
                     if (output.size() > 0) {
                        var prevValue = output.getLast();

                        var isValid = switch (prevValue) {
                           case 0 -> value == 1;
                           case 1 -> value == 0;
                           default -> false;
                        };
                        if (!isValid) {
                           continue outer;
                        }
                     } else if (value != 0) {
                        continue outer;
                     }
                     output.add(value);
                     if (output.size() >= 500) {
                        break outer;
                     }
                  }
                  default -> throw new RuntimeException("unknown instruction: " + instruction[0]);
               }
               programCounter++;
            }
         }
         System.out.println(aValue);
      } catch (Exception e) {
         e.printStackTrace();
         System.exit(1);
      }
   }

   public static void main(String[] args) {
      var start = Instant.now();

      new Task().task();

      System.out.println("Done in " + Duration.between(start, Instant.now()).toString().substring(2).toLowerCase());
   }
}
