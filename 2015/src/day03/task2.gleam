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

fn task2() -> Nil {
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
    |> get_visited_houses(
      set.from_list([starting_position]),
      starting_position,
      starting_position,
      True,
    )
    |> int.to_string

  io.println(result)
}

fn get_visited_houses(
  directions: List(#(Int, Int)),
  visited: set.Set(#(Int, Int)),
  santa_position: #(Int, Int),
  robo_santa_position: #(Int, Int),
  is_santas_turn: Bool,
) -> Int {
  case directions {
    [curr_direction, ..directions] -> {
      case is_santas_turn {
        True -> {
          let santa_position = #(
            santa_position.0 + curr_direction.0,
            santa_position.1 + curr_direction.1,
          )

          let visited = set.insert(visited, santa_position)
          get_visited_houses(
            directions,
            visited,
            santa_position,
            robo_santa_position,
            False,
          )
        }
        False -> {
          let robo_santa_position = #(
            robo_santa_position.0 + curr_direction.0,
            robo_santa_position.1 + curr_direction.1,
          )
          let visited = set.insert(visited, robo_santa_position)
          get_visited_houses(
            directions,
            visited,
            santa_position,
            robo_santa_position,
            True,
          )
        }
      }
    }
    _ -> set.size(visited)
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
