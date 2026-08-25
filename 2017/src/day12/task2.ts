import path from "node:path";

const PATH = path.join("inputs", "day12", "input.txt");

async function task2() {
   const connections = (await Bun.file(PATH).text())
      .trim()
      .split("\n")
      .reduce((connections, line) => {
         const [program, cnxs] = line.split(" <-> ");
         connections.set(+program!, cnxs!.split(", ").map(Number));
         return connections;
      }, new Map<number, number[]>());

   const disjointSet = new DisjointSet(connections.size);

   for (const entry of connections.entries()) {
      entry[1].forEach((v) => disjointSet.unite(entry[0], v));
   }

   console.log(disjointSet.countGroups());
}

class DisjointSet {
   size: number;
   parent: number[];

   constructor(size: number) {
      this.size = size;
      this.parent = Array.from({ length: size }, (_, i) => i);
   }

   find(i: number): number {
      if (this.parent[i] === i) {
         return i;
      }

      const parent = this.find(this.parent[i]!);
      this.parent[i] = parent;
      return parent;
   }

   unite(i: number, j: number) {
      const irep = this.find(i);
      const jrep = this.find(j);

      this.parent[irep] = jrep;
   }

   countGroups() {
      const groups = new Set<number>();
      for (let i = 0; i < this.size; i++) {
         groups.add(this.find(i));
      }

      return groups.size;
   }
}

console.time("Task Done");
await task2();
console.timeEnd("Task Done");
