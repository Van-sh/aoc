import path from "node:path";

const PATH = path.join("inputs", "day14", "input.txt");

async function task1() {
   const key = (await Bun.file(PATH).text()).trim();

   const grid = Array.from({ length: 128 }).map(() => Array.from({ length: 128 }).map(() => false));
   for (let i = 0; i < grid.length; i++) {
      const hash = knotHash(`${key}-${i}`);
      for (let j = 0; j < grid[i]!.length / 8; j++) {
         const u8 = hash[j]!;
         for (let k = 0; k < 8; k++) {
            const mask = 1 << (7 - k);
            if (u8 & mask) {
               grid[i]![8 * j + k] = true;
            }
         }
      }
   }

   const groups = Array.from({ length: 128 }).map(() => Array.from({ length: 128 }).map(() => 0));
   const queue = [] as [number, number][];
   let currGroup = 1;
   for (let i = 0; i < grid.length; i++) {
      const row = grid[i]!;
      for (let j = 0; j < row.length; j++) {
         if (groups[i]![j]) {
            continue;
         }
         if (!row[j]) {
            continue;
         }

         queue.push([i, j]);
         while (queue.length) {
            const [y, x] = queue.shift()!;
            // console.log(x, y);

            groups[y]![x] = currGroup;
            for (let delY = -1; delY < 2; delY += 2) {
               const newY = y + delY;
               if (0 > newY || newY >= grid.length) {
                  continue;
               }
               const group = groups[newY]![x];
               if (group) {
                  if (group === currGroup) {
                     continue;
                  } else {
                     console.log(groups);

                     throw new Error("Found a different group as a neighbour");
                  }
               }
               if (!grid[newY]![x]) {
                  continue;
               }

               queue.push([newY, x]);
            }
            for (let delX = -1; delX < 2; delX += 2) {
               const newX = x + delX;
               if (0 > newX || newX >= grid[y]!.length) {
                  continue;
               }
               const group = groups[y]![newX];
               if (group) {
                  if (group === currGroup) {
                     continue;
                  } else {
                     console.log(groups);

                     throw new Error("Found a different group as a neighbour");
                  }
               }
               if (!grid[y]![newX]) {
                  continue;
               }

               queue.push([y, newX]);
            }
         }
         currGroup += 1;
      }
   }
   const result = currGroup - 1;
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
