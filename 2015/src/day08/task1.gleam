import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import gleam/time/duration
import gleam/time/timestamp
import simplifile

const path: String = "inputs/day08/input.txt"

fn task1() -> Nil {
  let result =
    simplifile.read(path)
    |> result.lazy_unwrap(fn() { panic as { "Failed to read " <> path } })
    |> string.trim
    |> string.split("\n")
    |> list.map(string.to_graphemes)
    |> list.fold(#(0, 0), count_characters)
    |> fn(counts) { counts.0 - counts.1 }
    |> int.to_string

  io.println(result)
}

fn count_characters(acc: #(Int, Int), line: List(String)) -> #(Int, Int) {
  case line {
    ["\"", ..rest_line] -> count_characters(#(acc.0 + 1, acc.1), rest_line)
    ["\\", "\\", ..rest_line] ->
      count_characters(#(acc.0 + 2, acc.1 + 1), rest_line)
    ["\\", "\"", ..rest_line] ->
      count_characters(#(acc.0 + 2, acc.1 + 1), rest_line)
    ["\\", "x", _, _, ..rest_line] ->
      count_characters(#(acc.0 + 4, acc.1 + 1), rest_line)
    [_, ..rest_line] -> count_characters(#(acc.0 + 1, acc.1 + 1), rest_line)
    [] -> acc
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
