import path from "node:path";

const PATH = path.join("inputs", "day13", "input.txt");

async function task2() {
   const scanners = (await Bun.file(PATH).text())
      .trim()
      .split("\n")
      .reduce((scanners, line) => {
         const segments = line.split(": ");
         scanners[+segments[0]!] = +segments[1]!;
         return scanners;
      }, [] as number[]);

   let result = 0;
   outer: for (let delay = 0; ; delay++) {
      for (let i = 0; i < scanners.length; i++) {
         const width = scanners[i]!;
         const t = delay + i;
         if (t % (2 * (width - 1)) === 0) {
            continue outer;
         }
      }
      result = delay;
      break;
   }
   console.log(result);
}

console.time("Task Done");
await task2();
console.timeEnd("Task Done");
