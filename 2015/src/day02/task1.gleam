import gleam/int
import gleam/io
import gleam/list
import gleam/order
import gleam/result
import gleam/string
import gleam/time/duration
import gleam/time/timestamp
import simplifile

const path: String = "inputs/day02/input.txt"

fn task1() -> Nil {
  let result =
    simplifile.read(path)
    |> result.lazy_unwrap(fn() { panic as { "Failed to read " <> path } })
    |> string.trim
    |> string.split("\n")
    |> list.map(fn(line) {
      string.split(line, "x")
      |> list.map(fn(dimension) {
        int.parse(dimension)
        |> result.lazy_unwrap(fn() {
          panic as { "Couldn't convert " <> dimension <> " to int" }
        })
      })
      |> fn(dimensions) {
        let assert [l, w, h] = dimensions
          as "dimensions should be a list of 3 elements"

        let min_side =
          list.max(dimensions, order.reverse(int.compare))
          |> result.lazy_unwrap(fn() { panic })

        2 * l * w + 2 * w * h + 2 * l * h + min_side
      }
    })
    |> list.fold(0, int.add)
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
    <> int.to_string(nanoseconds) |> string.pad_start(9, "0")
    <> "ns",
  )
}
