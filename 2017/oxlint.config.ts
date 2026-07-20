import { defineConfig } from "oxlint";

export default defineConfig({
   plugins: ["typescript", "unicorn", "oxc"],
   categories: {
      correctness: "error",
   },
   options: {
      typeAware: true,
   },
   rules: {},
   env: {
      builtin: true,
   },
});
