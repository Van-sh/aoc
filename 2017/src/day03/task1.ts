import path from "node:path";

const PATH = path.join("inputs", "day03", "input.txt");

async function task1() {
   const input = +(await Bun.file(PATH).text()).trim();

   const state = {
      value: 1,
      x: 0,
      y: 0,
      limit: 1,
      direction: "right",
   } satisfies State as State;

   while (state.value != input) {
      state.value++;
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
   }

   console.log(Math.abs(state.x) + Math.abs(state.y));
}

type State = {
   value: number;
   x: number;
   y: number;
   limit: number;
   direction: "up" | "right" | "down" | "left";
};

console.time("Task Done");
await task1();
console.timeEnd("Task Done");
