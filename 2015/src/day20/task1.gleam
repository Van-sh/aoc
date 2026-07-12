import gleam/float
import gleam/int
import gleam/io
import gleam/result
import gleam/string
import gleam/time/duration
import gleam/time/timestamp
import simplifile

const path: String = "inputs/day20/input.txt"

fn task1() -> Nil {
  let result =
    simplifile.read(path)
    |> result.lazy_unwrap(fn() { panic as { "Failed to read " <> path } })
    |> string.trim
    |> int.parse
    |> result.lazy_unwrap(fn() { panic as "Couldn't parse input" })
    |> find_lowest_number_with_presents(1)
    |> int.to_string

  io.println(result)
}

fn find_lowest_number_with_presents(presents: Int, house: Int) -> Int {
  case number_of_presents_delivered(house) > presents {
    False -> find_lowest_number_with_presents(presents, house + 1)
    True -> house
  }
}

fn number_of_presents_delivered(house: Int) -> Int {
  let sqrt =
    int.square_root(house)
    |> result.lazy_unwrap(fn() {
      panic as { "house(" <> int.to_string(house) <> ") is negative" }
    })
    |> float.ceiling
    |> float.truncate

  let presents = case sqrt * sqrt == house {
    True -> sqrt * 10
    False -> 0
  }

  use presents, num <- int.range(1, sqrt, presents)
  case house % num {
    0 -> presents + num * 10 + house / num * 10
    _ -> presents
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
