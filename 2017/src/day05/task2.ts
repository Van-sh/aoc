import path from "node:path";

const PATH = path.join("inputs", "day05", "input.txt");

async function task1() {
   const jumps = (await Bun.file(PATH).text()).trim().split("\n").map(Number);

   let i = 0;
   let steps = 0;
   while (i < jumps.length) {
      const offset = jumps[i]!;

      if (jumps[i]! < 3) jumps[i]!++;
      else jumps[i]!--;

      i += offset;
      steps++;
   }
   console.log(steps);
}

console.time("Task Done");
await task1();
console.timeEnd("Task Done");
