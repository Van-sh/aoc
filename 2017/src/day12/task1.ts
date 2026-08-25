import path from "node:path";

const PATH = path.join("inputs", "day12", "input.txt");

async function task1() {
   const connections = (await Bun.file(PATH).text())
      .trim()
      .split("\n")
      .reduce((connections, line) => {
         const [program, cnxs] = line.split(" <-> ");
         connections.set(+program!, cnxs!.split(", ").map(Number));
         return connections;
      }, new Map<number, number[]>());
   const visited: boolean[] = [true];
   const queue = [0];

   let result = 0;
   for (let program = queue.shift(); typeof program === "number"; program = queue.shift()) {
      result += 1;
      connections.get(program)!.forEach((cnx) => {
         if (visited[cnx]) return;
         visited[cnx] = true;
         queue.push(cnx);
      });
   }
   console.log(result);
}

console.time("Task Done");
await task1();
console.timeEnd("Task Done");
