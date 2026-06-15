import gleam/int
import gleam/io
import gleam/list
import gleam/string
import gleam/time/duration
import gleam/time/timestamp
import simplifile

const path = "inputs/day01/input.txt"

fn task1() -> Nil {
  let result =
    case simplifile.read(path) {
      Ok(content) -> content
      Error(_) -> panic as "file was not found"
    }
    |> string.to_graphemes
    |> list.map(fn(char: String) {
      case char {
        "(" -> 1
        ")" -> -1
        _ -> panic as "unexpected character"
      }
    })
    |> list.fold(0, fn(acc: Int, direction: Int) { acc + direction })
    |> int.to_string

  io.println(result)
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
