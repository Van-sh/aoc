import path from "node:path";

const PATH = path.join("inputs", "day04", "input.txt");

async function task1() {
   const result = (await Bun.file(PATH).text())
      .trim()
      .split("\n")
      .map((line) => {
         const words = new Set<string>();

         let isValid = line.split(" ").every((word) => {
            if (words.has(word)) return false;

            words.add(word);
            return true;
         });
         return isValid ? 1 : (0 as number);
      })
      .reduce((acc, val) => acc + val);

   console.log(result);
}

console.time("Task Done");
await task1();
console.timeEnd("Task Done");
