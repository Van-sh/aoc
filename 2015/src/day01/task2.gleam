import gleam/int
import gleam/io
import gleam/list
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
    |> string.to_graphemes
    |> list.map(fn(char) {
      case char {
        "(" -> 1
        ")" -> -1
        _ -> panic as "unexpected character"
      }
    })
    |> find_index_for_first_character_to_reach_basement(0, _, 1)
    |> int.to_string

  io.println(result)
}

fn find_index_for_first_character_to_reach_basement(
  floor: Int,
  directions: List(Int),
  index: Int,
) -> Int {
  let assert [curr_direction, ..directions] = directions
    as "we should never have an empty list as long as we enter basement at any point in time"

  let floor = floor + curr_direction
  case floor < 0 {
    True -> index
    False ->
      find_index_for_first_character_to_reach_basement(
        floor,
        directions,
        index + 1,
      )
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
    <> int.to_string(nanoseconds)
    <> "ns",
  )
}
