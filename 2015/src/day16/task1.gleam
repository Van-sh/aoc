import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import gleam/time/duration
import gleam/time/timestamp
import simplifile

const path: String = "inputs/day16/input.txt"

fn task1() -> Nil {
  let detected_compounds =
    dict.from_list([
      #("children", "3"),
      #("cats", "7"),
      #("samoyeds", "2"),
      #("pomeranians", "3"),
      #("akitas", "0"),
      #("vizslas", "0"),
      #("goldfish", "5"),
      #("trees", "3"),
      #("cars", "2"),
      #("perfumes", "1"),
    ])

  let result =
    simplifile.read(path)
    |> result.lazy_unwrap(fn() { panic as { "Failed to read " <> path } })
    |> string.trim
    |> string.split("\n")
    |> list.map(fn(line) {
      let #(aunt, details) =
        string.split_once(line, ": ")
        |> result.lazy_unwrap(fn() { panic as { "Failed to split: " <> line } })

      let details =
        string.split(details, ", ")
        |> list.map(fn(detail) {
          let assert [compound, amount] = string.split(detail, ": ")
          #(compound, amount)
        })

      #(aunt, details)
    })
    |> list.filter(fn(aunt) {
      let #(_, compounds) = aunt
      list.all(compounds, fn(compound) {
        dict.get(detected_compounds, compound.0) == Ok(compound.1)
      })
    })
    |> fn(aunt) {
      let assert [aunt] = aunt
      aunt.0
    }

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
