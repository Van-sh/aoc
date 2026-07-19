package day08.task1;

import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Duration;
import java.time.Instant;

public class Task1 {
   Path path = Path.of("inputs", "day08", "input.txt");

   void task() {
      try {
         var lines = Files.readAllLines(this.path);
         var screen = new Screen();

         for (var line : lines) {
            if (line.startsWith("rect")) {
               var dimensions = line.substring(5).split("x");

               screen.rect(Integer.parseInt(dimensions[0]), Integer.parseInt(dimensions[1]));
               continue;
            }

            if (line.contains("row")) {
               var dimensions = line.split("=")[1].split(" by ");

               screen.rotateRow(Integer.parseInt(dimensions[0]), Integer.parseInt(dimensions[1]));
               continue;
            }

            if (line.contains("column")) {
               var dimensions = line.split("=")[1].split(" by ");

               screen.rotateColumn(Integer.parseInt(dimensions[0]), Integer.parseInt(dimensions[1]));
               continue;
            }
            throw new RuntimeException("Unknown line: " + line);
         }
         System.out.println(screen.countLitPixels());
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

class Screen {
   static int rows = 6, cols = 50;
   boolean[][] screen = new boolean[Screen.rows][Screen.cols];

   void rect(int width, int height) {
      for (int i = 0; i < height; i++) {
         for (int j = 0; j < width; j++) {
            screen[i][j] = true;
         }
      }
   }

   void rotateRow(int row, int shift) {
      var buf = new boolean[Screen.cols - shift];

      for (var i = 0; i < buf.length; i++) {
         buf[i] = this.screen[row][i];
      }
      for (var i = 0; i < shift; i++) {
         this.screen[row][i] = this.screen[row][buf.length + i];
      }
      for (var i = 0; i < buf.length; i++) {
         this.screen[row][shift + i] = buf[i];
      }
   }

   void rotateColumn(int col, int shift) {
      var buf = new boolean[Screen.rows - shift];

      for (var i = 0; i < buf.length; i++) {
         buf[i] = this.screen[i][col];
      }
      for (var i = 0; i < shift; i++) {
         this.screen[i][col] = this.screen[buf.length + i][col];
      }
      for (var i = 0; i < buf.length; i++) {
         this.screen[shift + i][col] = buf[i];
      }
   }

   int countLitPixels() {
      var litPixels = 0;
      for (var i = 0; i < Screen.rows; i++) {
         for (var j = 0; j < Screen.cols; j++) {
            if (this.screen[i][j]) {
               litPixels += 1;
            }
         }
      }
      return litPixels;
   }
}