import gleam/int
import gleam/io
import gleam/list
import gleam/order
import gleam/result
import gleam/string
import gleam/time/duration
import gleam/time/timestamp
import simplifile

const path: String = "inputs/day24/input.txt"

fn task2() -> Nil {
  let packages =
    simplifile.read(path)
    |> result.lazy_unwrap(fn() { panic as { "Failed to read " <> path } })
    |> string.trim
    |> string.split("\n")
    |> list.fold([], fn(acc, line) {
      let assert Ok(weight) = int.parse(line)
      [weight, ..acc]
    })

  let total_weight = int.sum(packages)
  let required_weight = total_weight / 4

  let result =
    int.range(1, list.length(packages) / 3, [], fn(acc, size) {
      case acc {
        [] -> {
          use packages <- list.filter_map(list.combinations(packages, size))
          case int.sum(packages) == required_weight {
            True -> Ok(packages)
            False -> Error(Nil)
          }
        }
        _ -> acc
      }
    })
    |> list.map(int.product)
    |> list.max(order.reverse(int.compare))
    |> result.lazy_unwrap(fn() { panic as "no solution found" })
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
    <> int.to_string(nanoseconds) |> string.pad_start(9, "0")
    <> "ns",
  )
}
