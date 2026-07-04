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

fn task2() -> Nil {
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

        let min_face_perimeter =
          list.max([l + w, w + h, l + h], order.reverse(int.compare))
          |> result.lazy_unwrap(fn() { panic })
          |> int.multiply(2)

        l * w * h + min_face_perimeter
      }
    })
    |> list.fold(0, int.add)
    |> int.to_string

  io.println(result)
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
