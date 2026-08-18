import path from "node:path";

const PATH = path.join("inputs", "day09", "input.txt");

async function task1() {
   const input = (await Bun.file(PATH).text()).trim();

   let result = 0;
   let level = 0;
   let isGarbage = false;
   for (let i = 0; i < input.length; i++) {
      const character = input.charAt(i);

      if (character == "!") {
         i += 1;
         continue;
      }
      if (isGarbage) {
         if (character == ">") {
            isGarbage = false;
         }
         continue;
      }

      switch (character) {
         case "{":
            level += 1;
            break;
         case "}":
            result += level;
            level -= 1;
            break;
         case "<":
            isGarbage = true;
            break;
      }
   }

   console.log(result);
}

console.time("Task Done");
await task1();
console.timeEnd("Task Done");
