import path from "node:path";

const PATH = path.join("inputs", "day02", "input.txt");

async function task1() {
   const result = (await Bun.file(PATH).text())
      .trim()
      .split("\n")
      .map((line) => {
         const numbers = line.split("\t");
         let min = Infinity;
         let max = 0;

         for (let number of numbers) {
            const num = +number;
            min = Math.min(min, num);
            max = Math.max(max, num);
         }

         return max - min;
      })
      .reduce((acc, val) => acc + val);

   console.log(result);
}

console.time("Task Done");
await task1();
console.timeEnd("Task Done");
