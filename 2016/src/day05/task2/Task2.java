package day05.task2;

import java.math.BigInteger;
import java.nio.file.Files;
import java.nio.file.Path;
import java.security.MessageDigest;
import java.time.Duration;
import java.time.Instant;

public class Task2 {
   Path path = Path.of("inputs", "day05", "input.txt");

   void task() {
      try {
         var doorId = Files.readString(this.path).trim();
         var chars = new char[8];
         var md5 = MessageDigest.getInstance("MD5");

         var suffix = 0;
         while (true) {
            suffix++;
            var hash = new BigInteger(1, md5.digest((doorId + suffix).getBytes())).toString(16);
            while (hash.length() < 32) {
               hash = "0" + hash;
            }
            if (hash.startsWith("00000")) {
               var pos = hash.charAt(5) - '0';
               if (pos > 7 || chars[pos] != 0) {
                  continue;
               }

               chars[pos] = hash.charAt(6);

               var charsLeft = false;
               for (var ch : chars) {
                  if (ch == 0) {
                     charsLeft = true;
                     break;
                  }
               }

               if (!charsLeft) {
                  break;
               }
            }
         }
         var result = new String(chars);
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
