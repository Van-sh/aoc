import path from "node:path";

const PATH = path.join("inputs", "day15", "input.txt");
const productFactorA = 16807;
const productFactorB = 48271;
const remainderFactor = 2147483647;

async function task2() {
   let [a, b] = (await Bun.file(PATH).text())
      .trim()
      .split("\n")
      .map((line) => +line.split(" ")[4]!) as [number, number];

   let result = 0;
   for (let i = 0; i < 5_000_000; i++) {
      while (true) {
         a = (a * productFactorA) % remainderFactor;
         if ((a & 3) === 0) {
            break;
         }
      }
      while (true) {
         b = (b * productFactorB) % remainderFactor;
         if ((b & 7) === 0) {
            break;
         }
      }

      if ((a & 0xffff) === (b & 0xffff)) {
         result += 1;
      }
   }

   console.log(result);
}

console.time("Task Done");
await task2();
console.timeEnd("Task Done");
