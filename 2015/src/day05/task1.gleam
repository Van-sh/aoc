import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import gleam/time/duration
import gleam/time/timestamp
import simplifile

const path: String = "inputs/day05/input.txt"

const blacklisted_strings: List(String) = ["ab", "cd", "pq", "xy"]

fn task1() -> Nil {
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
  has_3_vowels(line)
  && string.to_graphemes(line) |> has_repeated_char
  && has_no_blacklisted_strings(line)
}

fn has_3_vowels(line: String) -> Bool {
  string.to_graphemes(line)
  |> list.fold(0, fn(vowel_count, char) {
    case char {
      "a" | "e" | "i" | "o" | "u" -> vowel_count + 1
      _ -> vowel_count
    }
  })
  |> fn(vowel_count) { vowel_count >= 3 }
}

fn has_repeated_char(graphemes: List(String)) -> Bool {
  case graphemes {
    [curr_grapheme, ..graphemes] -> {
      case graphemes {
        [next_grapheme, ..] if curr_grapheme == next_grapheme -> True
        _ -> has_repeated_char(graphemes)
      }
    }
    _ -> False
  }
}

fn has_no_blacklisted_strings(line: String) -> Bool {
  list.all(blacklisted_strings, fn(blacklisted_string) {
    !string.contains(line, blacklisted_string)
  })
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
