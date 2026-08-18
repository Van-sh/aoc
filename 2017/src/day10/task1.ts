import path from "node:path";

const PATH = path.join("inputs", "day10", "input.txt");
const LENGTH = 256;

async function task1() {
   const input = (await Bun.file(PATH).text()).trim().split(",").map(Number);
   const list = Array.from({ length: LENGTH }).map((_, i) => i);

   let current = 0;
   let skip = 0;

   for (const offset of input) {
      if (offset > LENGTH) {
         throw new Error("Invalid input");
      }
      const endIndex = (current + offset - 1) % LENGTH;

      for (let i = 0; i < Math.floor(offset / 2); i++) {
         const left = (current + i) % LENGTH;
         let right = endIndex - i;
         if (right < 0) {
            right += LENGTH;
         }

         list[left]! ^= list[right]!;
         list[right]! ^= list[left]!;
         list[left]! ^= list[right]!;
      }

      current = (current + offset + skip) % LENGTH;
      skip += 1;
   }

   console.log(list[0]! * list[1]!);
}

console.time("Task Done");
await task1();
console.timeEnd("Task Done");
