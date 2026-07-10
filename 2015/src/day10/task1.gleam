import gleam/int
import gleam/io
import gleam/result
import gleam/string
import gleam/time/duration
import gleam/time/timestamp
import simplifile

const path: String = "inputs/day10/input.txt"

fn task1() -> Nil {
  let result =
    simplifile.read(path)
    |> result.lazy_unwrap(fn() { panic as { "Failed to read " <> path } })
    |> string.trim
    |> string.to_graphemes
    |> look_and_say_repeat(40)
    |> string.length
    |> int.to_string

  io.println(result)
}

fn look_and_say_repeat(input: List(String), times: Int) -> String {
  case times {
    0 -> string.join(input, "")
    _ -> {
      let assert [first_character, ..] = input as "Got empty input"
      let input =
        look_and_say(input, first_character, 0, "")
        |> string.to_graphemes
      look_and_say_repeat(input, times - 1)
    }
  }
}

fn look_and_say(
  input: List(String),
  current_char: String,
  count: Int,
  output: String,
) -> String {
  case input {
    [first, ..input] if first == current_char ->
      look_and_say(input, first, count + 1, output)
    [first, ..input] -> {
      let output = output <> int.to_string(count) <> current_char
      look_and_say(input, first, 1, output)
    }
    [] -> output <> int.to_string(count) <> current_char
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
