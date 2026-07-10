import gleam/bit_array
import gleam/crypto
import gleam/int
import gleam/io
import gleam/result
import gleam/string
import gleam/time/duration
import gleam/time/timestamp
import simplifile

const path: String = "inputs/day04/input.txt"

fn task1() -> Nil {
  let result =
    simplifile.read(path)
    |> result.lazy_unwrap(fn() { panic as { "Failed to read " <> path } })
    |> find_result(1)
    |> int.to_string

  io.println(result)
}

fn find_result(input: String, suffix: Int) -> Int {
  let hashed_data =
    { input <> int.to_string(suffix) }
    |> bit_array.from_string
    |> crypto.hash(crypto.Md5, _)
    |> bit_array.base16_encode

  case hashed_data {
    "00000" <> _ -> suffix
    _ -> find_result(input, suffix + 1)
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
