package day05.task1;

import java.math.BigInteger;
import java.nio.file.Files;
import java.nio.file.Path;
import java.security.MessageDigest;
import java.time.Duration;
import java.time.Instant;

public class Task1 {
   Path path = Path.of("inputs", "day05", "input.txt");

   void task() {
      try {
         var doorId = Files.readString(this.path).trim();
         var result = new StringBuilder();
         var md5 = MessageDigest.getInstance("MD5");

         var suffix = 0;
         while (result.length() < 8) {
            suffix++;
            var hash = new BigInteger(1, md5.digest((doorId + suffix).getBytes())).toString(16);
            while (hash.length() < 32) {
               hash = "0" + hash;
            }
            if (hash.startsWith("00000")) {
               result.append(hash.charAt(5));
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
