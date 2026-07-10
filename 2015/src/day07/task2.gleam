import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import gleam/time/duration
import gleam/time/timestamp
import simplifile

const path: String = "inputs/day07/input.txt"

fn task2() -> Nil {
  let instructions =
    simplifile.read(path)
    |> result.lazy_unwrap(fn() { panic as { "Failed to read " <> path } })
    |> string.trim
    |> string.split("\n")
    |> list.fold(dict.new(), fn(instructions, line) {
      let assert [val, wire] = string.split(line, " -> ")
        as { "Unexpected line: " <> line }

      dict.insert(instructions, wire, string.split(val, " "))
    })
  let a = find_value_of(instructions, "a") |> int.to_string
  let instructions = dict.insert(instructions, "b", [a])

  let result =
    find_value_of(instructions, "a")
    |> int.to_string

  io.println(result)
}

fn find_value_of(
  instructions: Dict(String, List(String)),
  wire: String,
) -> Int {
  let #(result, _) = memoized_find_value_of(instructions, wire, dict.new())

  result
}

fn memoized_find_value_of(
  instructions: Dict(String, List(String)),
  wire: String,
  memo: Dict(String, Int),
) -> #(Int, Dict(String, Int)) {
  let #(value, memo) = case dict.get(memo, wire) {
    Ok(value) -> #(value, memo)
    Error(_) -> {
      case int.parse(wire) {
        Ok(value) -> #(value, memo)
        Error(_) -> {
          let instruction =
            dict.get(instructions, wire)
            |> result.lazy_unwrap(fn() {
              panic as { "Wire not found: " <> wire }
            })
          case instruction {
            [value] -> memoized_find_value_of(instructions, value, memo)
            [value1, "AND", value2] -> {
              let #(value1, memo) =
                memoized_find_value_of(instructions, value1, memo)
              let #(value2, memo) =
                memoized_find_value_of(instructions, value2, memo)
              #(int.bitwise_and(value1, value2), memo)
            }
            [value1, "OR", value2] -> {
              let #(value1, memo) =
                memoized_find_value_of(instructions, value1, memo)
              let #(value2, memo) =
                memoized_find_value_of(instructions, value2, memo)
              #(int.bitwise_or(value1, value2), memo)
            }
            [value1, "LSHIFT", value2] -> {
              let #(value1, memo) =
                memoized_find_value_of(instructions, value1, memo)
              let #(value2, memo) =
                memoized_find_value_of(instructions, value2, memo)
              #(int.bitwise_shift_left(value1, value2), memo)
            }
            [value1, "RSHIFT", value2] -> {
              let #(value1, memo) =
                memoized_find_value_of(instructions, value1, memo)
              let #(value2, memo) =
                memoized_find_value_of(instructions, value2, memo)

              #(int.bitwise_shift_right(value1, value2), memo)
            }
            ["NOT", value] -> {
              let #(value, memo) =
                memoized_find_value_of(instructions, value, memo)
              #(int.bitwise_not(value), memo)
            }
            _ ->
              panic as {
                "Unexpected instruction: " <> string.join(instruction, " ")
              }
          }
        }
      }
    }
  }

  let memo = dict.insert(memo, wire, value)
  #(value, memo)
}

pub fn main() -> Nil {
  let start = timestamp.system_time()

  task2()

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
