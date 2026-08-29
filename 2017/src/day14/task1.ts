import path from "node:path";

const PATH = path.join("inputs", "day14", "input.txt");

async function task1() {
   const key = (await Bun.file(PATH).text()).trim();

   let result = 0;
   for (let i = 0; i < 128; i++) {
      const hash = knotHash(`${key}-${i}`);
      for (let u8 of hash) {
         while (u8) {
            if (u8 & 1) {
               result += 1;
            }
            u8 >>= 1;
         }
      }
   }
   console.log(result);
}

const LENGTH = 256;
const suffix = [17, 31, 73, 47, 23] as const;

function knotHash(input: string) {
   const bytes = input
      .trim()
      .split("")
      .map((c) => c.charCodeAt(0))
      .concat(suffix);
   const list = Array.from({ length: LENGTH }).map((_, i) => i);

   let current = 0;
   let skip = 0;

   for (let iter = 0; iter < 64; iter++) {
      for (const offset of bytes) {
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

   return denseHash;
}

console.time("Task Done");
await task1();
console.timeEnd("Task Done");
