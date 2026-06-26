import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import gleam/time/duration
import gleam/time/timestamp
import simplifile

const path = "inputs/day14/input.txt"

const total_time = 2503

fn task1() -> Nil {
  let result =
    simplifile.read(path)
    |> result.lazy_unwrap(fn() { panic as { "Failed to read " <> path } })
    |> string.trim
    |> string.split("\n")
    |> list.map(string.split(_, " "))
    |> list.map(fn(line) {
      case line {
        [_, _, _, speed, _, _, runtime, _, _, _, _, _, _, rest_time, _] -> {
          let assert [speed, runtime, rest_time] =
            [speed, runtime, rest_time]
            |> list.map(fn(val) {
              int.parse(val)
              |> result.lazy_unwrap(fn() {
                panic as { "Couldn't parse " <> val }
              })
            })
          let time_period = runtime + rest_time

          { total_time / time_period * speed * runtime }
          + { int.min(total_time % time_period, runtime) * speed }
        }
        _ -> panic as { "Unexpected line: " <> string.join(line, " ") }
      }
    })
    |> list.max(int.compare)
    |> result.lazy_unwrap(fn() { panic })
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
