import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{None, Some}
import gleam/result
import gleam/set
import gleam/string
import gleam/time/duration
import gleam/time/timestamp
import simplifile

const path: String = "inputs/day19/input.txt"

fn task1() -> Nil {
  let #(replacements, initial_molecule) =
    simplifile.read(path)
    |> result.lazy_unwrap(fn() { panic as { "Failed to read " <> path } })
    |> string.trim
    |> string.split_once("\n\n")
    |> result.lazy_unwrap(fn() { panic as "Input didn't have two sections" })

  let replacements =
    string.split(replacements, "\n")
    |> list.map(string.split(_, " "))
    |> list.fold(dict.new(), fn(replacements, line) {
      case line {
        [from, "=>", to] ->
          dict.upsert(replacements, from, fn(val) {
            case val {
              None -> [to]
              Some(val) -> [to, ..val]
            }
          })
        _ -> panic as { "Unexpected line: " <> string.join(line, " ") }
      }
    })

  let initial_molecule =
    string.to_graphemes(initial_molecule) |> combine_pascal_case([], "")

  let result =
    dict.fold(replacements, set.new(), fn(acc, from, to) {
      list.index_map(initial_molecule, fn(element, i) {
        case element == from {
          True -> {
            let #(first, last) = list.split(initial_molecule, i)
            let last = list.drop(last, 1)

            list.map(to, fn(replacement) {
              list.append(first, [replacement, ..last]) |> string.join("")
            })
          }
          False -> []
        }
      })
      |> list.flatten
      |> set.from_list
      |> set.union(acc)
    })
    |> set.size
    |> int.to_string

  io.println(result)
}

fn combine_pascal_case(
  characters: List(String),
  out: List(String),
  intermediate: String,
) -> List(String) {
  case characters {
    [char, ..rest] -> {
      case is_uppercase(char) {
        True ->
          case intermediate == "" {
            True -> combine_pascal_case(rest, out, char)
            False -> combine_pascal_case(rest, [intermediate, ..out], char)
          }
        False -> combine_pascal_case(rest, out, intermediate <> char)
      }
    }
    [] -> [intermediate, ..out] |> list.reverse
  }
}

fn is_uppercase(in: String) -> Bool {
  in == string.uppercase(in)
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
