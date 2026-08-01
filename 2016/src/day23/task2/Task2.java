package day23.task2;

import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Duration;
import java.time.Instant;
import java.util.HashMap;

public class Task2 {
   Path path = Path.of("inputs", "day23", "input.txt");

   void task() {
      try (var lines = Files.lines(this.path)) {
         var registers = new HashMap<String, Integer>();
         registers.put("a", 12);
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
                     var offset = switch (instruction[2]) {
                        case "a", "b", "c", "d" -> registers.get(instruction[2]);
                        default -> Integer.parseInt(instruction[2]);
                     };
                     if (offset == -2) {
                        var checkInstructionForMultiply = instructions.get(programCounter + 2);
                        if (checkInstructionForMultiply[0].equals("jnz")
                              && checkInstructionForMultiply[2].equals("-5")) {

                           var val1 = Math.abs(registers.get(instructions.get(programCounter - 1)[1])) + 1;
                           var val2 = Math.abs(registers.get(instructions.get(programCounter + 1)[1]));

                           var multipliedInstruction = instructions.get(programCounter - 2);

                           registers.put(instructions.get(programCounter - 1)[1], 0);
                           registers.put(instructions.get(programCounter + 1)[1], 0);

                           registers.put(multipliedInstruction[1],
                                 registers.get(multipliedInstruction[1])
                                       + (multipliedInstruction[0].equals("inc") ? -1 : 1)
                                       + ((multipliedInstruction[0].equals("inc") ? 1 : -1) * val1 * val2));

                           offset = 3;
                        }
                     }
                     programCounter += offset;
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

      new Task2().task();

      System.out.println("Done in " + Duration.between(start, Instant.now()).toString().substring(2).toLowerCase());
   }
}
