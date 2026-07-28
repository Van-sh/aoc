package day14.task2;

import java.math.BigInteger;
import java.nio.file.Files;
import java.nio.file.Path;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.time.Duration;
import java.time.Instant;
import java.util.HashMap;
import java.util.regex.Pattern;

public class Task2 {
   Path path = Path.of("inputs", "day14", "input.txt");

   void task() {
      try {
         var salt = Files.readString(this.path).trim();
         var md5 = new Md5Cacher();

         var pattern = Pattern.compile(".*?(.)\\1{2}.*");

         var keysFound = 0;
         var result = 0;

         for (var suffix = 0; keysFound < 64; suffix++) {
            var hash = md5.hash(salt + suffix);
            var matcher = pattern.matcher(hash);
            if (!matcher.matches()) {
               continue;
            }
            var valid = false;
            for (var i = 1; i <= 1000; i++) {
               var check = md5.hash(salt + (suffix + i));
               if (!check.contains(matcher.group(1).repeat(5))) {
                  continue;
               }
               valid = true;
               keysFound++;
               if (keysFound == 64) {
                  result = suffix;
               }
               break;
            }
            if (!valid) {
               continue;
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

class Md5Cacher {
   static HashMap<String, String> cache = new HashMap<>();
   MessageDigest md5;

   Md5Cacher() throws NoSuchAlgorithmException {
      this.md5 = MessageDigest.getInstance("MD5");
   }

   String hash(String input) {
      var value = Md5Cacher.cache.get(input);
      if (value != null) {
         return value;
      }

      value = input;
      for (var i = 0; i < 2017; i++) {
         value = new BigInteger(1, md5.digest((value).getBytes())).toString(16);
         value = "0".repeat(32 - value.length()) + value;
      }

      Md5Cacher.cache.put(input, value);
      return value;
   }
}