import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import gleam/time/duration
import gleam/time/timestamp
import simplifile

const path: String = "inputs/day25/input.txt"

const start: #(#(Int, Int), Int) = #(#(6, 6), 27_995_004)

fn task() -> Nil {
  let result =
    simplifile.read(path)
    |> result.lazy_unwrap(fn() { panic as { "Failed to read " <> path } })
    |> string.trim
    |> string.replace(",", "")
    |> string.replace(".", "")
    |> string.split(" ")
    |> list.reverse
    |> fn(input) {
      case input {
        [col, _, row, ..] -> {
          let assert [Ok(row), Ok(col)] = list.map([row, col], int.parse)
            as { "Couldn't parse: " <> string.inspect(#(row, col)) }

          #(row, col)
        }
        _ ->
          panic as {
            "Unexpected input: " <> string.inspect(list.reverse(input))
          }
      }
    }
    |> solve(start, _)
    |> int.to_string

  io.println(result)
}

fn solve(state: #(#(Int, Int), Int), target_position: #(Int, Int)) -> Int {
  let #(position, value) = state

  case position == target_position {
    True -> value
    False -> {
      let value = { value * 252_533 } % 33_554_393
      let next_position = case position.0 {
        1 -> #(position.1 + 1, 1)
        _ -> #(position.0 - 1, position.1 + 1)
      }
      solve(#(next_position, value), target_position)
    }
  }
}

pub fn main() -> Nil {
  let start = timestamp.system_time()

  task()

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
