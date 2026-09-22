import path from "node:path";

const PATH = path.join("inputs", "day16", "input.txt");

async function task1() {
   let result = (await Bun.file(PATH).text())
      .trim()
      .split(",")
      .map((move) => [move.charAt(0), move.substring(1)] as [string, string])
      .reduce((acc, move) => {
         switch (move[0]) {
            case "s":
               const offset = +move[1];
               return acc.substring(acc.length - offset) + acc.substring(0, acc.length - offset);
            case "x":
               const positions = move[1]
                  .split("/")
                  .map(Number)
                  .sort((a, b) => a - b) as [number, number];
               return (
                  acc.substring(0, positions[0]) +
                  acc.charAt(positions[1]) +
                  acc.substring(positions[0] + 1, positions[1]) +
                  acc.charAt(positions[0]) +
                  acc.substring(positions[1] + 1)
               );
            case "p":
               const partners = move[1].split("/") as [string, string];
               return acc
                  .replace(partners[0], "#")
                  .replace(partners[1], partners[0])
                  .replace("#", partners[1]);
            default:
               throw new Error(`Unknown move: ${move[0]}`);
         }
      }, "abcdefghijklmnop");

   console.log(result);
}

console.time("Task Done");
await task1();
console.timeEnd("Task Done");
