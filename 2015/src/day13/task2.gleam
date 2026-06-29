import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/set
import gleam/string
import gleam/time/duration
import gleam/time/timestamp
import simplifile

const path: String = "inputs/day13/input.txt"

fn task2() -> Nil {
  let input =
    simplifile.read(path)
    |> result.lazy_unwrap(fn() { panic as { "Failed to read " <> path } })
    |> string.trim
    |> string.split("\n")
    |> list.map(string.split(_, " "))

  let attendees =
    list.map(input, fn(line) {
      case line {
        [attendee, ..] -> attendee
        _ ->
          panic as {
            "Couldn't find attendee in line: " <> string.join(line, " ")
          }
      }
    })
    |> set.from_list
    |> set.to_list

  let happiness_association =
    list.map(input, fn(line) {
      case line {
        [target, _, "gain", points, _, _, _, _, _, _, source] -> {
          let source = string.slice(source, 0, string.length(source) - 1)
          let points =
            int.parse(points)
            |> result.lazy_unwrap(fn() {
              panic as { "Unable to parse " <> points }
            })
          #(#(target, source), points)
        }
        [target, _, "lose", points, _, _, _, _, _, _, source] -> {
          let source = string.slice(source, 0, string.length(source) - 1)
          let points =
            int.parse(points)
            |> result.lazy_unwrap(fn() {
              panic as { "Unable to parse " <> points }
            })
          #(#(target, source), -points)
        }
        _ -> panic as { "Unexpected line: " <> string.join(line, " ") }
      }
    })
    |> dict.from_list

  let happiness_association =
    list.fold(attendees, [], fn(acc, attendee) {
      [#(#("_", attendee), 0), #(#(attendee, "_"), 0), ..acc]
    })
    |> dict.from_list
    |> dict.merge(happiness_association)

  let attendees = ["_", ..attendees]

  let result =
    list.permutations(attendees)
    |> list.map(fn(attendees) {
      let first =
        list.first(attendees)
        |> result.lazy_unwrap(fn() {
          panic as { "No first attendee in " <> string.inspect(attendees) }
        })
      let last =
        list.last(attendees)
        |> result.lazy_unwrap(fn() {
          panic as { "No last attendee in " <> string.inspect(attendees) }
        })

      list.window_by_2(attendees)
      |> list.fold(
        get_happiness_change_for_a_pair(#(first, last), happiness_association),
        fn(happinesss_change, pair) {
          happinesss_change
          + get_happiness_change_for_a_pair(pair, happiness_association)
        },
      )
    })
    |> list.max(int.compare)
    |> result.lazy_unwrap(fn() { panic as "Attendees lsit was empty" })
    |> int.to_string

  io.println(result)
}

fn get_happiness_change_for_a_pair(
  pair: #(String, String),
  happiness_association: Dict(#(String, String), Int),
) -> Int {
  dict.get(happiness_association, pair)
  |> result.lazy_unwrap(fn() {
    panic as {
      "Couldn't find happiness change for pair: " <> string.inspect(pair)
    }
  })
  |> int.add(
    dict.get(happiness_association, #(pair.1, pair.0))
    |> result.lazy_unwrap(fn() {
      panic as {
        "Couldn't find happiness change for pair: "
        <> string.inspect(#(pair.1, pair.0))
      }
    }),
  )
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
