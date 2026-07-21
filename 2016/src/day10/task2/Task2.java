package day10.task2;

import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Duration;
import java.time.Instant;
import java.util.HashMap;

public class Task2 {
   Path path = Path.of("inputs", "day10", "input.txt");
   HashMap<Integer, Bot> bots = new HashMap<>();
   HashMap<Integer, Output> outputs = new HashMap<>();

   void task() {
      try {
         var lines = Files.readAllLines(this.path);

         var startBot = (Bot) null;
         var startBotSecondValue = -1;
         for (var line : lines) {
            if (line.startsWith("value")) {
               var sections = line.split(" ");
               var value = Integer.parseInt(sections[1]);
               var botId = Integer.parseInt(sections[5]);

               var bot = this.bots.get(botId);
               if (bot == null) {
                  bot = new Bot();
                  bot.id = botId;
                  this.bots.put(botId, bot);
               }
               if (bot.chipValue == -1) {
                  this.giveValueToBot(bot, value);
               } else {
                  startBot = bot;
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

               var bot = this.bots.get(botId);
               if (bot == null) {
                  bot = new Bot();
                  bot.id = botId;
                  this.bots.put(botId, bot);
               }

               if (lowIsBot) {
                  var lowBot = this.bots.get(lowId);
                  if (lowBot == null) {
                     lowBot = new Bot();
                     lowBot.id = lowId;
                     this.bots.put(lowId, lowBot);
                  }
                  bot.lowSink = lowBot;
               } else {
                  var lowOutput = this.outputs.get(lowId);
                  if (lowOutput == null) {
                     lowOutput = new Output();
                     this.outputs.put(lowId, lowOutput);
                  }
                  bot.lowSink = lowOutput;
               }

               if (highIsBot) {
                  var highBot = this.bots.get(highId);
                  if (highBot == null) {
                     highBot = new Bot();
                     highBot.id = highId;
                     this.bots.put(highId, highBot);
                  }
                  bot.highSink = highBot;
               } else {
                  var highOutput = this.outputs.get(highId);
                  if (highOutput == null) {
                     highOutput = new Output();
                     this.outputs.put(highId, highOutput);
                  }
                  bot.highSink = highOutput;
               }

               continue;
            }
            throw new RuntimeException("Unknown line: " + line);
         }

         this.giveValueToBot(startBot, startBotSecondValue);
         var result = this.outputs.get(0).chipValue * this.outputs.get(1).chipValue * this.outputs.get(2).chipValue;
         System.out.println(result);
      } catch (Exception e) {
         e.printStackTrace();
         System.exit(1);
      }
   }

   void giveValueToBot(Bot bot, int value) {
      if (bot.chipValue == -1) {
         bot.chipValue = value;
         return;
      }

      var low = Math.min(bot.chipValue, value);
      var high = Math.max(bot.chipValue, value);

      bot.chipValue = -1;

      if (bot.lowSink != null) {
         switch (bot.lowSink) {
            case Bot lowBot -> this.giveValueToBot(lowBot, low);
            case Output lowOutput -> lowOutput.chipValue = low;
            default -> throw new RuntimeException("Unknown Sink: " + bot.lowSink);
         }
      }
      if (bot.highSink != null) {
         switch (bot.highSink) {
            case Bot highBot -> this.giveValueToBot(highBot, high);
            case Output highOutput -> highOutput.chipValue = high;
            default -> throw new RuntimeException("Unknown Sink: " + bot.highSink);
         }
      }
   }

   public static void main(String[] args) {
      var start = Instant.now();

      new Task2().task();

      System.out.println("Done in " + Duration.between(start, Instant.now()).toString().substring(2).toLowerCase());
   }
}

interface Sink {
}

class Bot implements Sink {
   int id = -1, chipValue = -1;
   Sink lowSink, highSink;
}

class Output implements Sink {
   int chipValue = -1;
}