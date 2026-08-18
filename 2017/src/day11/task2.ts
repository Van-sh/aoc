import path from "node:path";

const PATH = path.join("inputs", "day11", "input.txt");

async function task2() {
   const input = (await Bun.file(PATH).text()).trim().split(",");
   const pos = { x: 0, y: 0 } satisfies Position;

   let result = 0;
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

      const absPos = {
         x: Math.abs(pos.x),
         y: Math.abs(pos.y),
      } satisfies Position;

      let distance = Math.min(absPos.x, absPos.y);
      absPos.x -= distance;
      absPos.y -= distance;

      if (absPos.x) {
         distance += absPos.x / 2;
      }
      if (absPos.y) {
         distance += absPos.y;
      }

      result = Math.max(result, distance);
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
await task2();
console.timeEnd("Task Done");
