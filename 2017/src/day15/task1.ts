import path from "node:path";

const PATH = path.join("inputs", "day15", "input.txt");
const productFactorA = 16807;
const productFactorB = 48271;
const remainderFactor = 2147483647;

async function task1() {
   let [a, b] = (await Bun.file(PATH).text())
      .trim()
      .split("\n")
      .map((line) => +line.split(" ")[4]!) as [number, number];

   let result = 0;
   for (let i = 0; i < 40_000_000; i++) {
      a = (a * productFactorA) % remainderFactor;
      b = (b * productFactorB) % remainderFactor;

      if ((a & 0xffff) === (b & 0xffff)) {
         result += 1;
      }
   }

   console.log(result);
}

console.time("Task Done");
await task1();
console.timeEnd("Task Done");
