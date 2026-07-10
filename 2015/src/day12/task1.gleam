import gleam/dict
import gleam/dynamic.{type Dynamic}
import gleam/dynamic/decode
import gleam/int
import gleam/io
import gleam/json
import gleam/list
import gleam/result
import gleam/string
import gleam/time/duration
import gleam/time/timestamp
import simplifile

const path: String = "inputs/day12/input.txt"

fn task1() -> Nil {
  let result =
    simplifile.read(path)
    |> result.lazy_unwrap(fn() { panic as { "Failed to read " <> path } })
    |> string.trim
    |> json.parse(decode.dynamic)
    |> result.lazy_unwrap(fn() { panic as "Failed to decode json" })
    |> sum_numbers
    |> int.to_string

  io.println(result)
}

fn sum_numbers(value: Dynamic) -> Int {
  case dynamic.classify(value) {
    "Dict" ->
      decode.run(value, decode.dict(decode.dynamic, decode.dynamic))
      |> result.lazy_unwrap(fn() {
        panic as { "Couldn't decode dict " <> string.inspect(value) }
      })
      |> dict.fold(0, fn(acc, key, val) {
        let acc = acc + sum_numbers(key)
        acc + sum_numbers(val)
      })
    "List" ->
      decode.run(value, decode.list(decode.dynamic))
      |> result.lazy_unwrap(fn() {
        panic as { "Couldn't decode list " <> string.inspect(value) }
      })
      |> list.fold(0, fn(acc, val) { acc + sum_numbers(val) })
    "Int" ->
      decode.run(value, decode.int)
      |> result.lazy_unwrap(fn() {
        panic as { "Couldn't decode int " <> string.inspect(value) }
      })
    _ -> {
      0
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
