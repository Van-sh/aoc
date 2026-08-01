import path from "node:path";

const PATH = path.join("inputs", "day02", "input.txt");

async function task1() {
   const result = (await Bun.file(PATH).text())
      .trim()
      .split("\n")
      .map((line) => {
         const numbers = line.split("\t").map(Number);

         for (let i = 0; i < numbers.length - 1; i++) {
            for (let j = i + 1; j < numbers.length; j++) {
               if (numbers[i]! % numbers[j]! == 0) {
                  return numbers[i]! / numbers[j]!;
               }
               if (numbers[j]! % numbers[i]! == 0) {
                  return numbers[j]! / numbers[i]!;
               }
            }
         }

         throw new Error("Unreachable");
      })
      .reduce((acc, val) => acc + val);

   console.log(result);
}

console.time("Task Done");
await task1();
console.timeEnd("Task Done");
