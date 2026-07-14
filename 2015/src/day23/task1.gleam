import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{Some}
import gleam/result
import gleam/string
import gleam/time/duration
import gleam/time/timestamp
import simplifile

const path: String = "inputs/day23/input.txt"

type Registers =
  Dict(String, Int)

fn task1() -> Nil {
  let result =
    simplifile.read(path)
    |> result.lazy_unwrap(fn() { panic as { "Failed to read " <> path } })
    |> string.trim
    |> string.replace(",", "")
    |> string.split("\n")
    |> list.map(string.split(_, " "))
    |> execute([], dict.from_list([#("a", 0), #("b", 0)]))
    |> get_register_value("b")
    |> int.to_string

  io.println(result)
}

fn execute(
  instructions: List(List(String)),
  prev_instructions: List(List(String)),
  registers: Registers,
) -> Registers {
  case instructions {
    [] -> registers
    [current_instruction, ..rest_instructions] -> {
      case current_instruction {
        // hlf r sets register r to half its current value, then continues with the next instruction.
        ["hlf", register] -> {
          upsert_register_value(registers, register, fn(val) { val / 2 })
          |> execute(
            rest_instructions,
            [current_instruction, ..prev_instructions],
            _,
          )
        }
        // tpl r sets register r to triple its current value, then continues with the next instruction.
        ["tpl", register] -> {
          upsert_register_value(registers, register, int.multiply(_, 3))
          |> execute(
            rest_instructions,
            [current_instruction, ..prev_instructions],
            _,
          )
        }
        // inc r increments register r, adding 1 to it, then continues with the next instruction.
        ["inc", register] -> {
          upsert_register_value(registers, register, int.add(_, 1))
          |> execute(
            rest_instructions,
            [current_instruction, ..prev_instructions],
            _,
          )
        }
        // jmp offset is a jump; it continues with the instruction offset away relative to itself.
        ["jmp", offset] -> {
          let #(instructions, prev_instructions) =
            apply_jump(offset, instructions, prev_instructions)

          execute(instructions, prev_instructions, registers)
        }
        // jie r, offset is like jmp, but only jumps if register r is even ("jump if even").
        ["jie", register, offset] -> {
          case get_register_value(registers, register) % 2 == 0 {
            True -> {
              let #(instructions, prev_instructions) =
                apply_jump(offset, instructions, prev_instructions)

              execute(instructions, prev_instructions, registers)
            }
            False ->
              execute(
                rest_instructions,
                [current_instruction, ..prev_instructions],
                registers,
              )
          }
        }
        // jio r, offset is like jmp, but only jumps if register r is 1 ("jump if one", not odd).
        ["jio", register, offset] -> {
          case get_register_value(registers, register) {
            1 -> {
              let #(instructions, prev_instructions) =
                apply_jump(offset, instructions, prev_instructions)

              execute(instructions, prev_instructions, registers)
            }
            _ ->
              execute(
                rest_instructions,
                [current_instruction, ..prev_instructions],
                registers,
              )
          }
        }
        _ ->
          panic as {
            "unknown instruction: " <> string.inspect(current_instruction)
          }
      }
    }
  }
}

fn apply_jump(
  offset: String,
  instructions: List(List(String)),
  prev_instructions: List(List(String)),
) -> #(List(List(String)), List(List(String))) {
  let assert Ok(offset) = int.parse(offset) as "invalid jump offset"

  case offset >= 0 {
    True -> {
      use #(instructions, prev_instructions), _ <- int.range(0, offset, #(
        instructions,
        prev_instructions,
      ))
      let assert [ins, ..instructions] = instructions
      #(instructions, [ins, ..prev_instructions])
    }
    False -> {
      use #(instructions, prev_instructions), _ <- int.range(0, -offset, #(
        instructions,
        prev_instructions,
      ))
      let assert [ins, ..prev_instructions] = prev_instructions
      #([ins, ..instructions], prev_instructions)
    }
  }
}

fn get_register_value(registers: Registers, register: String) -> Int {
  case register {
    "a" | "b" -> {
      dict.get(registers, register)
      |> result.lazy_unwrap(fn() {
        panic as { "register \"" <> register <> "\" doesn't have a value" }
      })
    }
    _ -> panic as "unknown register"
  }
}

fn upsert_register_value(
  registers: Registers,
  register: String,
  fun: fn(Int) -> Int,
) -> Registers {
  case register {
    "a" | "b" -> {
      use value <- dict.upsert(registers, register)
      let assert Some(value) = value

      fun(value)
    }
    _ -> panic as "unknown register"
  }
}

pub fn main() -> Nil {
  let start = timestamp.system_time()

  task1()

  let #(seconds, nanoseconds) =
    timestamp.difference(start, timestamp.system_time())
    |> duration.to_seconds_and_nanoseconds()
  io.println(
    "Done in "
    <> int.to_string(seconds)
    <> "s and "
    <> int.to_string(nanoseconds) |> string.pad_start(9, "0")
    <> "ns",
  )
}
