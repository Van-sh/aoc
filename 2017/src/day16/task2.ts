import path from "node:path";

const PATH = path.join("inputs", "day16", "input.txt");
const START = "abcdefghijklmnop";

async function task2() {
   let moves = (await Bun.file(PATH).text())
      .trim()
      .split(",")
      .map((move) => {
         switch (move.charAt(0)) {
            case "s":
               return { type: "s", offset: +move.substring(1) };
            case "x":
               return {
                  type: "x",
                  positions: move
                     .substring(1)
                     .split("/")
                     .map(Number)
                     .sort((a, b) => a - b),
               };
            case "p":
               return { type: "p", partners: move.substring(1).split("/") };
            default:
               throw new Error(`Unknown move: ${move}`);
         }
      }) as Move[];

   let result = START;
   for (let i = 0; i < 1_000_000_000; i++) {
      if (i % 1_000 === 0) {
         console.log(i);
      }
      result = moves.reduce((acc, move) => {
         switch (move.type) {
            case "s":
               return (
                  acc.substring(acc.length - move.offset) +
                  acc.substring(0, acc.length - move.offset)
               );
            case "x":
               return [
                  acc.substring(0, move.positions[0]),
                  acc.charAt(move.positions[1]),
                  acc.substring(move.positions[0] + 1, move.positions[1]),
                  acc.charAt(move.positions[0]),
                  acc.substring(move.positions[1] + 1),
               ].join("");
            case "p":
               return acc
                  .replace(move.partners[0], "#")
                  .replace(move.partners[1], move.partners[0])
                  .replace("#", move.partners[1]);
            default:
               throw new Error(`${move satisfies never as string} doesn't exist`);
         }
      }, result);
      if (result === START) {
         i = 999_999_999 - (1_000_000_000 % (i + 1));
         console.log("oh ma gawd", i);
      }
   }

   console.log(result);
}

type Move =
   | { type: "s"; offset: number }
   | { type: "x"; positions: [number, number] }
   | { type: "p"; partners: [string, string] };

console.time("Task Done");
await task2();
console.timeEnd("Task Done");
