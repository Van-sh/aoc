import path from "node:path";

const PATH = path.join("inputs", "day06", "input.txt");

async function task2() {
   let banks = (await Bun.file(PATH).text()).trim().split("\t").map(Number);
   const prevStates = [[...banks]];

   let i = 0;
   let result = 0;
   while (true) {
      i++;

      let max = Math.max(...banks);
      const maxIdx = banks.findIndex((i) => i === max);

      banks[maxIdx] = 0;

      for (let j = (maxIdx + 1) % banks.length; max > 0; max--, j = (j + 1) % banks.length) {
         banks[j]!++;
      }

      let matchIdx = prevStates.findIndex((state) => {
         for (let j = 0; j < state.length; j++) {
            if (state[j] !== banks[j]) {
               return false;
            }
         }
         return true;
      });
      if (matchIdx !== -1) {
         result = i - matchIdx;
         break;
      }
      prevStates.push([...banks]);
   }
   console.log(result);
}

console.time("Task Done");
await task2();
console.timeEnd("Task Done");
