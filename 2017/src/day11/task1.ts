// Looked stuff up after writing the code for hexagonal grids: https://www.redblobgames.com/grids/hexagons/

import path from "node:path";

const PATH = path.join("inputs", "day11", "input.txt");

async function task1() {
   const input = (await Bun.file(PATH).text()).trim().split(",");
   const pos = { x: 0, y: 0 } satisfies Position;

   for (const direction of input) {
      switch (direction) {
         case "n":
            pos.x += 2;
            break;
         case "s":
            pos.x -= 2;
            break;
         case "ne":
            pos.x += 1;
            pos.y += 1;
            break;
         case "nw":
            pos.x += 1;
            pos.y -= 1;
            break;
         case "se":
            pos.x -= 1;
            pos.y += 1;
            break;
         case "sw":
            pos.x -= 1;
            pos.y -= 1;
            break;
      }
   }

   const absPos = {
      x: Math.abs(pos.x),
      y: Math.abs(pos.y),
   } satisfies Position;

   let result = Math.min(absPos.x, absPos.y);
   absPos.x -= result;
   absPos.y -= result;

   if (absPos.x) {
      result += absPos.x / 2;
   }
   if (absPos.y) {
      result += absPos.y;
   }

   console.log(result);
}

type Position = {
   /** 1 per diagonal */
   x: number;
   /** 1 per diagonal */
   y: number;
};

console.time("Task Done");
await task1();
console.timeEnd("Task Done");
