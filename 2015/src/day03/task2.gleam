import gleam/int
import gleam/io
import gleam/result
import gleam/set.{type Set}
import gleam/string
import gleam/time/duration
import gleam/time/timestamp
import simplifile

const path: String = "inputs/day03/input.txt"

const starting_position: #(Int, Int) = #(0, 0)

type State {
  State(
    santa_position: #(Int, Int),
    robo_santa_position: #(Int, Int),
    visited: Set(#(Int, Int)),
    is_santas_turn: Bool,
  )
}

fn task2() -> Nil {
  let result =
    simplifile.read(path)
    |> result.lazy_unwrap(fn() { panic as { "Failed to read " <> path } })
    |> get_visited_houses(State(
      starting_position,
      starting_position,
      set.from_list([starting_position]),
      True,
    ))
    |> int.to_string

  io.println(result)
}

fn get_visited_houses(input: String, state: State) -> Int {
  case input {
    "" -> set.size(state.visited)
    "^" <> rest_input ->
      move(state, #(0, -1)) |> get_visited_houses(rest_input, _)
    "v" <> rest_input ->
      move(state, #(0, 1)) |> get_visited_houses(rest_input, _)
    "<" <> rest_input ->
      move(state, #(-1, 0)) |> get_visited_houses(rest_input, _)
    ">" <> rest_input ->
      move(state, #(1, 0)) |> get_visited_houses(rest_input, _)
    _ -> panic as "unexpected character"
  }
}

fn move(state: State, direction: #(Int, Int)) {
  case state.is_santas_turn {
    True -> {
      let santa_position = #(
        state.santa_position.0 + direction.0,
        state.santa_position.1 + direction.1,
      )

      let visited = set.insert(state.visited, santa_position)
      State(..state, santa_position:, visited:, is_santas_turn: False)
    }
    False -> {
      let robo_santa_position = #(
        state.robo_santa_position.0 + direction.0,
        state.robo_santa_position.1 + direction.1,
      )
      let visited = set.insert(state.visited, robo_santa_position)
      State(..state, robo_santa_position:, visited:, is_santas_turn: True)
    }
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
