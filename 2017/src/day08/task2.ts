import path from "node:path";

const PATH = path.join("inputs", "day08", "input.txt");

async function task2() {
   const result = (await Bun.file(PATH).text())
      .trim()
      .split("\n")
      .map((line) => {
         let [statement, condition] = line.split(" if ");
         let segments = statement!.split(" ");

         let register = segments[0]!;
         let isIncrement = segments[1]! == "inc";
         let change = +segments[2]!;

         let conditionSegments = condition!.split(" ");

         return {
            register,
            isIncrement,
            change,
            condition: [conditionSegments[0]!, conditionSegments[1]!, +conditionSegments[2]!],
         } satisfies Instruction;
      })
      .reduce(
         ([maxValue, registers], { register, change, isIncrement, condition }) => {
            let runInstruction = false;
            switch (condition[1]) {
               case "==":
                  runInstruction = registers.getOrInsert(condition[0], 0) == condition[2];
                  break;
               case "!=":
                  runInstruction = registers.getOrInsert(condition[0], 0) != condition[2];
                  break;
               case "<":
                  runInstruction = registers.getOrInsert(condition[0], 0) < condition[2];
                  break;
               case "<=":
                  runInstruction = registers.getOrInsert(condition[0], 0) <= condition[2];
                  break;
               case ">":
                  runInstruction = registers.getOrInsert(condition[0], 0) > condition[2];
                  break;
               case ">=":
                  runInstruction = registers.getOrInsert(condition[0], 0) >= condition[2];
                  break;
               default:
                  throw new Error(`Unknown logical operator: ${condition[1]} (${registers.size})`);
            }
            if (!runInstruction) {
               return [maxValue, registers] as const;
            }

            const originalValue = registers.getOrInsert(register, 0);
            const modifiedValue = isIncrement ? originalValue + change : originalValue - change;

            registers.set(register, modifiedValue);
            return [Math.max(maxValue, modifiedValue), registers] as const;
         },
         [Number.MIN_SAFE_INTEGER, new Map<string, number>()] as const,
      )[0];

   console.log(result);
}

type Instruction = {
   register: string;
   isIncrement: boolean;
   change: number;
   condition: [string, string, number];
};

console.time("Task Done");
await task2();
console.timeEnd("Task Done");
