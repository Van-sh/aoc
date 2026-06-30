import gleam/int
import gleam/io
import gleam/list
import gleam/order.{Eq, Gt, Lt}
import gleam/result
import gleam/string
import gleam/time/duration
import gleam/time/timestamp
import simplifile

const path: String = "inputs/day17/input.txt"

const eggnog = 150

fn task2() -> Nil {
  let result =
    simplifile.read(path)
    |> result.lazy_unwrap(fn() { panic as { "Failed to read " <> path } })
    |> string.trim
    |> string.split("\n")
    |> list.map(fn(line) {
      int.parse(line)
      |> result.lazy_unwrap(fn() {
        panic as { "Couldn't parse line: " <> line }
      })
    })
    |> find_combinations_that_fit_eggnog(eggnog)
    |> list.map(list.length)
    |> fn(combination_lengths) {
      let min_count =
        list.max(combination_lengths, order.reverse(int.compare))
        |> result.lazy_unwrap(fn() { panic })

      list.filter(combination_lengths, fn(length) { length == min_count })
      |> list.length
    }
    |> int.to_string

  io.println(result)
}

fn find_combinations_that_fit_eggnog(
  containers: List(Int),
  required_eggnog: Int,
) -> List(List(Int)) {
  case int.compare(required_eggnog, 0) {
    Eq -> [[]]
    Lt -> []
    Gt ->
      case containers {
        [container, ..containers] ->
          find_combinations_that_fit_eggnog(
            containers,
            required_eggnog - container,
          )
          |> list.map(fn(combination) { [container, ..combination] })
          |> list.append(find_combinations_that_fit_eggnog(
            containers,
            required_eggnog,
          ))
        _ -> []
      }
  }
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
