import path from "node:path";

const PATH = path.join("inputs", "day03", "input.txt");

async function task1() {
   const input = +(await Bun.file(PATH).text()).trim();

   const state = {
      grid: { "0,0": 1 },
      x: 0,
      y: 0,
      limit: 1,
      direction: "right",
   } satisfies State as State;

   while (state.grid[`${state.x},${state.y}`]! < input) {
      switch (state.direction) {
         case "left":
            state.x--;
            if (state.x > state.limit) {
               break;
            }
            state.limit = -state.limit;
            state.direction = "down";
            break;
         case "right":
            state.x++;
            if (state.x < state.limit) {
               break;
            }
            state.limit = -state.limit;
            state.direction = "up";
            break;
         case "up":
            state.y--;
            if (state.y > state.limit) {
               break;
            }
            state.direction = "left";
            break;
         case "down":
            state.y++;
            if (state.y < state.limit) {
               break;
            }
            state.limit++;
            state.direction = "right";
            break;
         default:
            throw new Error(`${state.direction satisfies never as string} doesn't exist`);
      }

      state.grid[`${state.x},${state.y}`] = 0;
      for (let x = -1; x < 2; x++) {
         for (let y = -1; y < 2; y++) {
            if (x === 0 && y === 0) continue;

            state.grid[`${state.x},${state.y}`]! +=
               state.grid[`${state.x + x},${state.y + y}`] ?? 0;
         }
      }
   }

   console.log(state.grid[`${state.x},${state.y}`]);
}

type State = {
   grid: Grid;
   x: number;
   y: number;
   limit: number;
   direction: "up" | "right" | "down" | "left";
};
type Grid = { [K: `${number},${number}`]: number };

console.time("Task Done");
await task1();
console.timeEnd("Task Done");
