import gleam/bit_array
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import gleam/time/duration
import gleam/time/timestamp
import simplifile

const path: String = "inputs/day05/input.txt"

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
  let chars = <<line:utf8>>
  has_repeated_char_pair(chars)
  && has_repeated_char_with_another_char_in_between(chars)
}

fn has_repeated_char_pair(chars: BitArray) -> Bool {
  case chars {
    <<one, two, rest:bits>> -> {
      let assert Ok(rest_string) = bit_array.to_string(rest) as "invalid string"
      let assert Ok(pair) = bit_array.to_string(<<one, two>>)
        as "invalid string"

      case string.contains(rest_string, pair) {
        False -> has_repeated_char_pair(<<two, rest:bits>>)
        True -> True
      }
    }
    _ -> False
  }
}

fn has_repeated_char_with_another_char_in_between(chars: BitArray) -> Bool {
  case chars {
    <<current, rest:bits>> -> {
      case rest {
        <<_, next_next, _:bits>> if current == next_next -> True
        _ -> has_repeated_char_with_another_char_in_between(rest)
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
    <> int.to_string(nanoseconds) |> string.pad_start(9, "0")
    <> "ns",
  )
}
