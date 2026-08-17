import path from "node:path";

const PATH = path.join("inputs", "day08", "input.txt");

async function task1() {
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
      .reduce((registers, { register, change, isIncrement, condition }) => {
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
            return registers;
         }

         const originalValue = registers.getOrInsert(register, 0);
         const modifiedValue = isIncrement ? originalValue + change : originalValue - change;

         registers.set(register, modifiedValue);
         return registers;
      }, new Map<string, number>())
      .entries()
      .reduce((maxValue, [_, value]) => Math.max(maxValue, value), Number.MIN_SAFE_INTEGER);

   console.log(result);
}

type Instruction = {
   register: string;
   isIncrement: boolean;
   change: number;
   condition: [string, string, number];
};

console.time("Task Done");
await task1();
console.timeEnd("Task Done");
