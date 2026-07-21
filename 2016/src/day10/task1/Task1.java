package day10.task1;

import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Duration;
import java.time.Instant;
import java.util.HashMap;

public class Task1 {
   Path path = Path.of("inputs", "day10", "input.txt");
   HashMap<Integer, Bot> bots = new HashMap<>();

   void task() {
      try {
         var lines = Files.readAllLines(this.path);

         var startBotId = -1;
         var startBotSecondValue = -1;
         for (var line : lines) {
            if (line.startsWith("value")) {
               var sections = line.split(" ");
               var value = Integer.parseInt(sections[1]);
               var botId = Integer.parseInt(sections[5]);

               if (this.bots.get(botId) == null) {
                  this.bots.put(botId, new Bot());
               }
               if (this.bots.get(botId).chipValue == -1) {
                  this.giveValueToBot(botId, value);
               } else {
                  startBotId = botId;
                  startBotSecondValue = value;
               }

               continue;
            }
            if (line.startsWith("bot")) {
               var sections = line.split(" ");
               var botId = Integer.parseInt(sections[1]);
               var lowIsBot = sections[5].equals("bot");
               var lowId = Integer.parseInt(sections[6]);
               var highIsBot = sections[10].equals("bot");
               var highId = Integer.parseInt(sections[11]);

               if (this.bots.get(botId) == null) {
                  this.bots.put(botId, new Bot());
               }
               var bot = this.bots.get(botId);
               if (lowIsBot)
                  bot.lowBot = lowId;
               if (highIsBot)
                  bot.highBot = highId;

               continue;
            }
            throw new RuntimeException("Unknown line: " + line);
         }

         var result = this.giveValueToBot(startBotId, startBotSecondValue);
         System.out.println(result);
      } catch (Exception e) {
         e.printStackTrace();
         System.exit(1);
      }
   }

   int giveValueToBot(int botId, int value) {
      var bot = this.bots.get(botId);

      if (bot.chipValue == -1) {
         bot.chipValue = value;
         return -1;
      }

      var low = Math.min(bot.chipValue, value);
      var high = Math.max(bot.chipValue, value);

      if (low == 17 && high == 61) {
         return botId;
      }

      bot.chipValue = -1;

      var result = -1;
      if (bot.lowBot != -1) {
         result = this.giveValueToBot(bot.lowBot, low);
      }
      if (result == -1 && bot.highBot != -1) {
         result = this.giveValueToBot(bot.highBot, high);
      }
      return result;
   }

   public static void main(String[] args) {
      var start = Instant.now();

      new Task1().task();

      System.out.println("Done in " + Duration.between(start, Instant.now()).toString().substring(2).toLowerCase());
   }
}

class Bot {
   int chipValue = -1, lowBot = -1, highBot = -1;
}
