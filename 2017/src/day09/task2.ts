import path from "node:path";

const PATH = path.join("inputs", "day09", "input.txt");

async function task2() {
   const input = (await Bun.file(PATH).text()).trim();

   let result = 0;
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
            continue;
         }
         result += 1;
         continue;
      }

      switch (character) {
         case "<":
            isGarbage = true;
            break;
      }
   }

   console.log(result);
}

console.time("Task Done");
await task2();
console.timeEnd("Task Done");
