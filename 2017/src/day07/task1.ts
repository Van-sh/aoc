import path from "node:path";

const PATH = path.join("inputs", "day07", "input.txt");

async function task1() {
   const lines = (await Bun.file(PATH).text()).trim().split("\n");
   const programs = lines.map((line) => line.split(" ")[0]!);
   const children = lines
      .filter((line) => line.includes("->"))
      .flatMap((line) => line.split("->")[1]!.trim().split(", "));

   let result = "";
   for (const program of programs) {
      if (!children.includes(program)) {
         result = program;
         break;
      }
   }

   console.log(result);
}

console.time("Task Done");
await task1();
console.timeEnd("Task Done");
