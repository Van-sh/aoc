import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import gleam/time/duration
import gleam/time/timestamp
import simplifile

const path = "inputs/day05/input.txt"

fn task2() -> Nil {
  let result =
    simplifile.read(path)
    |> result.lazy_unwrap(fn() { panic as { "Failed to read " <> path } })
    |> string.trim
    |> string.split("\n")
    |> list.filter(is_string_nice)
    |> list.length
    |> int.to_string

  io.println(result)
}

fn is_string_nice(line: String) -> Bool {
  let line_graphemes = string.to_graphemes(line)
  has_repeated_char_pair(line_graphemes)
  && has_repeated_char_with_another_char_in_between(line_graphemes)
}

fn has_repeated_char_pair(graphemes: List(String)) -> Bool {
  case graphemes {
    [one, two, ..graphemes] -> {
      case
        string.join(graphemes, "")
        |> string.contains(string.join([one, two], ""))
      {
        False -> has_repeated_char_pair([two, ..graphemes])
        True -> True
      }
    }
    _ -> False
  }
}

fn has_repeated_char_with_another_char_in_between(
  graphemes: List(String),
) -> Bool {
  case graphemes {
    [curr_grapheme, ..graphemes] -> {
      case graphemes {
        [_, next_next_grapheme, ..] if curr_grapheme == next_next_grapheme ->
          True
        _ -> has_repeated_char_with_another_char_in_between(graphemes)
      }
    }
    _ -> False
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
