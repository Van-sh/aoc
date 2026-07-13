import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import gleam/time/duration
import gleam/time/timestamp
import simplifile
import splitter.{type Splitter}

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
  has_3_vowels(line, splitter.new(["a", "e", "i", "o", "u"]), 0)
  && has_repeated_char(<<line:utf8>>)
  && has_no_blacklisted_strings(line)
}

fn has_3_vowels(line: String, splitter: Splitter, count: Int) -> Bool {
  case splitter.split(splitter, line) {
    #(_, "", _) -> count >= 3
    #(_, _, rest) -> has_3_vowels(rest, splitter, count + 1)
  }
}

fn has_repeated_char(chars: BitArray) -> Bool {
  case chars {
    <<current, next, _:bits>> if current == next -> True
    <<_, chars:bits>> -> has_repeated_char(chars)
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
    <> int.to_string(nanoseconds) |> string.pad_start(9, "0")
    <> "ns",
  )
}
