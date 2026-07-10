import gleam/int
import gleam/io
import gleam/list
import gleam/order.{Eq, Gt, Lt}
import gleam/result
import gleam/string
import gleam/time/duration
import gleam/time/timestamp
import simplifile

const path: String = "inputs/day17/input.txt"

const eggnog: Int = 150

fn task1() -> Nil {
  let result =
    simplifile.read(path)
    |> result.lazy_unwrap(fn() { panic as { "Failed to read " <> path } })
    |> string.trim
    |> string.split("\n")
    |> list.map(fn(line) {
      int.parse(line)
      |> result.lazy_unwrap(fn() {
        panic as { "Couldn't parse line: " <> line }
      })
    })
    |> count_combinations_that_fit_eggnog(eggnog)
    |> int.to_string

  io.println(result)
}

fn count_combinations_that_fit_eggnog(
  containers: List(Int),
  required_eggnog: Int,
) -> Int {
  case int.compare(required_eggnog, 0) {
    Eq -> 1
    Lt -> 0
    Gt ->
      case containers {
        [container, ..containers] ->
          count_combinations_that_fit_eggnog(
            containers,
            required_eggnog - container,
          )
          + count_combinations_that_fit_eggnog(containers, required_eggnog)
        _ -> 0
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
