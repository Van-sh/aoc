import gleam/int
import gleam/io
import gleam/result
import gleam/string
import gleam/time/duration
import gleam/time/timestamp
import simplifile
import splitter.{type Splitter}

const path: String = "inputs/day10/input.txt"

fn task1() -> Nil {
  let result =
    simplifile.read(path)
    |> result.lazy_unwrap(fn() { panic as { "Failed to read " <> path } })
    |> string.trim
    |> look_and_say_repeat(
      50,
      splitter.new(["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]),
    )
    |> string.length
    |> int.to_string

  io.println(result)
}

fn look_and_say_repeat(
  input: String,
  times: Int,
  digit_splitter: Splitter,
) -> String {
  case times {
    0 -> input
    _ -> {
      let assert Ok(first_character) = string.first(input) as "Got empty input"

      look_and_say(input, first_character, 0, digit_splitter, "")
      |> look_and_say_repeat(times - 1, digit_splitter)
    }
  }
}

fn look_and_say(
  input: String,
  current_digit: String,
  count: Int,
  digit_splitter: Splitter,
  output: String,
) -> String {
  case splitter.split_after(digit_splitter, input) {
    #("", "") -> output <> int.to_string(count) <> current_digit
    #(first, rest) if first == current_digit ->
      look_and_say(rest, first, count + 1, digit_splitter, output)
    #(first, rest) -> {
      let output = output <> int.to_string(count) <> current_digit
      look_and_say(rest, first, 1, digit_splitter, output)
    }
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
