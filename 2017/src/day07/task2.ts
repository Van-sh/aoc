import path from "node:path";

const PATH = path.join("inputs", "day07", "input.txt");

const graph = new Map<string, ProgramMetaData>();
const weights = new Map<string, number>();

async function task2() {
   const lines = (await Bun.file(PATH).text()).trim().split("\n");

   const children = lines
      .filter((line) => line.includes("->"))
      .flatMap((line) => line.split("->")[1]!.trim().split(", "));

   lines.forEach((line) => {
      const segments = line.split(" ");
      const weightSegment = segments[1]!;
      graph.set(segments[0]!, {
         weight: +weightSegment.substring(1, weightSegment.length - 1),
         children: line.includes("->") ? line.split("->")[1]!.trim().split(", ") : [],
      });
   });

   let start = "";
   for (const program of graph.keys()) {
      if (!children.includes(program)) {
         start = program;
         break;
      }
   }

   const result = solve(start);
   console.log(result);
}

function solve(name: string): number {
   const weight = weights.get(name);
   if (weight) {
      return -1;
   }
   const metadata = graph.get(name)!;
   const checks = metadata.children.map(solve);
   const solution = checks.find((s) => s !== -1);
   if (solution) {
      return solution;
   }

   const childrenWeights = metadata.children.map((name) => weights.get(name)!);
   if (childrenWeights.some((e, _, arr) => e !== arr[0])) {
      const anomalyIdx =
         childrenWeights[0] === childrenWeights[1]
            ? childrenWeights.findIndex((w, _, arr) => w !== arr[0])
            : childrenWeights[0] == childrenWeights[2]
              ? 1
              : 0;

      const goodIdx = (anomalyIdx + 1) % childrenWeights.length;
      const difference = childrenWeights[anomalyIdx]! - childrenWeights[goodIdx]!;

      return graph.get(metadata.children[anomalyIdx]!)!.weight - difference;
   }

   const result = childrenWeights.reduce((acc, val) => acc + val, metadata.weight)!;
   weights.set(name, result);
   return -1;
}

type ProgramMetaData = {
   weight: number;
   children: string[];
};

console.time("Task Done");
await task2();
console.timeEnd("Task Done");
