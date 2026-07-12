import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/set.{type Set}
import gleam/string
import gleam/time/duration
import gleam/time/timestamp
import gleamy/priority_queue.{type Queue}
import simplifile

const path: String = "inputs/day19/input.txt"

type Distance {
  Distance(molecule: String, steps: Int)
}

fn task2() -> Nil {
  let #(replacements, final_molecule) =
    simplifile.read(path)
    |> result.lazy_unwrap(fn() { panic as { "Failed to read " <> path } })
    |> string.trim
    |> string.split_once("\n\n")
    |> result.lazy_unwrap(fn() { panic as "Input didn't have two sections" })

  let reverse_replacements =
    string.split(replacements, "\n")
    |> list.map(string.split(_, " "))
    |> list.fold([], fn(replacements, line) {
      case line {
        [from, "=>", to] -> [#(to, from), ..replacements]
        _ -> panic as { "Unexpected line: " <> string.join(line, " ") }
      }
    })
    |> list.sort(fn(a, b) {
      int.compare(string.length(a.0), string.length(b.0))
    })

  let heap =
    priority_queue.from_list([Distance(final_molecule, 0)], fn(a, b) {
      int.compare(
        string.length(a.molecule) / a.steps,
        string.length(b.molecule) / b.steps,
      )
    })
  let result =
    solve(heap, reverse_replacements, set.new())
    |> int.to_string

  io.println(result)
}

fn solve(
  distances: Queue(Distance),
  reverse_replacements: List(#(String, String)),
  visited: Set(String),
) -> Int {
  let assert Ok(#(current, distances)) = priority_queue.pop(distances)
    as "Distances was empty"

  case current.molecule {
    "e" -> current.steps
    _ -> {
      let #(distances, visited) =
        list.fold(reverse_replacements, #(distances, visited), fn(acc, val) {
          let #(distances, visited) = acc
          let #(to, from) = val

          case string.contains(current.molecule, to) {
            False -> #(distances, visited)
            True -> {
              let replaced = replace_once(current.molecule, to, from)
              case
                set.contains(visited, replaced),
                string.contains(replaced, "e") && replaced != "e"
              {
                False, False -> {
                  let visited = set.insert(visited, replaced)
                  let distances =
                    priority_queue.push(
                      distances,
                      Distance(replaced, current.steps + 1),
                    )

                  #(distances, visited)
                }
                _, _ -> #(distances, visited)
              }
            }
          }
        })
      solve(distances, reverse_replacements, visited)
    }
  }
}

pub fn replace_once(
  input: String,
  pattern: String,
  substitute: String,
) -> String {
  let input_length = string.length(input)
  let pattern_length = string.length(pattern)
  let cropped_length = string.crop(input, pattern) |> string.length

  string.slice(input, 0, input_length - cropped_length)
  <> substitute
  <> string.slice(
    input,
    input_length - cropped_length + pattern_length,
    cropped_length - pattern_length,
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
    <> int.to_string(nanoseconds) |> string.pad_start(9, "0")
    <> "ns",
  )
}
