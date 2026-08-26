import path from "node:path";

const PATH = path.join("inputs", "day13", "input.txt");

async function task1() {
   const result = (await Bun.file(PATH).text())
      .trim()
      .split("\n")
      .reduce((scanners, line) => {
         const segments = line.split(": ");
         scanners[+segments[0]!] = +segments[1]!;
         return scanners;
      }, [] as number[])
      .reduce((detectCount, width, t) => {
         if (t % (2 * (width - 1)) === 0) {
            return detectCount + t * width;
         }

         return detectCount;
      }, 0);

   console.log(result);
}

console.time("Task Done");
await task1();
console.timeEnd("Task Done");
