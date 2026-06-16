import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/set
import gleam/string
import gleam/time/duration
import gleam/time/timestamp
import simplifile

const path = "inputs/day03/input.txt"

fn task1() -> Nil {
  let starting_position = #(0, 0)

  let result =
    simplifile.read(path)
    |> result.lazy_unwrap(fn() { panic as { "Failed to read " <> path } })
    |> string.to_graphemes
    |> list.map(fn(char) {
      case char {
        "^" -> #(0, -1)
        "v" -> #(0, 1)
        "<" -> #(-1, 0)
        ">" -> #(1, 0)
        _ -> panic as "unexpected character"
      }
    })
    |> get_visited_houses(set.from_list([starting_position]), starting_position)
    |> int.to_string

  io.println(result)
}

fn get_visited_houses(
  directions: List(#(Int, Int)),
  visited: set.Set(#(Int, Int)),
  position: #(Int, Int),
) -> Int {
  case directions {
    [curr_direction, ..directions] -> {
      let position = #(
        position.0 + curr_direction.0,
        position.1 + curr_direction.1,
      )

      let visited = set.insert(visited, position)
      get_visited_houses(directions, visited, position)
    }
    _ -> set.size(visited)
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
    <> int.to_string(nanoseconds)
    <> "ns",
  )
}
