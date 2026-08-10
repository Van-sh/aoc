import path from "node:path";

const PATH = path.join("inputs", "day04", "input.txt");

async function task2() {
   const result = (await Bun.file(PATH).text())
      .trim()
      .split("\n")
      .map((line) => {
         let isValid = line.split(" ").every((word, idx, words) => {
            for (let i = idx + 1; i < words.length; i++) {
               const checkWord = words[i]!;

               if (word.length !== checkWord.length) continue;

               const letterCounts = new Map<string, { self: number; other: number }>();
               for (let j = 0; j < word.length; j++) {
                  letterCounts.getOrInsert(word.charAt(j), { self: 0, other: 0 }).self++;
                  letterCounts.getOrInsert(checkWord.charAt(j), { self: 0, other: 0 }).other++;
               }

               const isAnagram = letterCounts
                  .entries()
                  .every(([_, counts]) => counts.self === counts.other);
               if (isAnagram) return false;
            }

            return true;
         });
         return isValid ? 1 : (0 as number);
      })
      .reduce((acc, val) => acc + val);

   console.log(result);
}

console.time("Task Done");
await task2();
console.timeEnd("Task Done");
