import path from "node:path";

const PATH = path.join("inputs", "day10", "input.txt");
const LENGTH = 256;
const suffix = [17, 31, 73, 47, 23] as const;

async function task2() {
   const input = (await Bun.file(PATH).text())
      .trim()
      .split("")
      .map((c) => c.charCodeAt(0))
      .concat(suffix);
   const list = Array.from({ length: LENGTH }).map((_, i) => i);

   let current = 0;
   let skip = 0;

   for (let iter = 0; iter < 64; iter++) {
      for (const offset of input) {
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
   }

   const denseHash = Array.from({ length: 16 }).map(() => 0);
   for (let i = 0; i < 16; i++) {
      for (let j = 16 * i; j < 16 * (i + 1); j++) {
         denseHash[i]! ^= list[j]!;
      }
   }

   const hash = Buffer.from(denseHash).toHex();

   console.log(hash);
}

console.time("Task Done");
await task2();
console.timeEnd("Task Done");
