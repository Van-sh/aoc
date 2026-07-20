import path from "node:path";

const PATH = path.join("inputs", "day01", "input.txt");

async function task2() {
   const input = (await Bun.file(PATH).text()).trim();

   let result = 0;
   for (let i = 0; i < input.length; i++) {
      if (input[i] == input[(i + input.length / 2) % input.length]) {
         result += parseInt(input[i]!);
      }
   }

   console.log(result);
}

console.time("Task Done");
await task2();
console.timeEnd("Task Done");
