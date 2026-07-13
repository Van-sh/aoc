import gleam/int
import gleam/io
import gleam/result
import gleam/string
import gleam/time/duration
import gleam/time/timestamp
import simplifile

const path: String = "inputs/day01/input.txt"

fn task2() -> Nil {
  let result =
    simplifile.read(path)
    |> result.lazy_unwrap(fn() { panic as { "Failed to read " <> path } })
    |> find_index_for_first_character_to_reach_basement(0, 1)
    |> int.to_string

  io.println(result)
}

fn find_index_for_first_character_to_reach_basement(
  input: String,
  floor: Int,
  index: Int,
) -> Int {
  case input {
    "(" <> rest_input ->
      find_index_for_first_character_to_reach_basement(
        rest_input,
        floor + 1,
        index + 1,
      )
    ")" <> rest_input -> {
      let floor = floor - 1
      case floor < 0 {
        True -> index
        False ->
          find_index_for_first_character_to_reach_basement(
            rest_input,
            floor,
            index + 1,
          )
      }
    }
    "" ->
      panic as "we should never have an empty input as long as we enter basement at any point in time"
    _ -> panic as "unexpected character"
  }
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
