import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{Some, None}
import gleam/result
import gleam/string
import gleam/time/duration
import gleam/time/timestamp
import simplifile

const path: String = "inputs/day06/input.txt"

fn task2() -> Nil {
  let result =
    simplifile.read(path)
    |> result.lazy_unwrap(fn() { panic as { "Failed to read " <> path } })
    |> string.trim
    |> string.split("\n")
    |> list.map(string.split(_, " "))
    |> list.fold(dict.new(), fn(grid, line) {
      case line {
        ["turn", mode, start, "through", end] -> {
          let start = extract_coord_from_string(start)
          let end = extract_coord_from_string(end)
          let value = case mode {
            "on" -> 1
            "off" -> -1
            _ -> panic as { "unexpected mode: " <> mode }
          }

          set_grid_values(grid, value, start, end, start)
        }
        ["toggle", start, "through", end] -> {
          let start = extract_coord_from_string(start)
          let end = extract_coord_from_string(end)
          let value = 2

          set_grid_values(grid, value, start, end, start)
        }
        _ -> panic as { "unexpected sentence: " <> string.join(line, " ") }
      }
    })
    |> dict.fold(0, fn(acc, _key, value) { acc + value })
    |> int.to_string

  io.println(result)
}

fn extract_coord_from_string(input: String) -> #(Int, Int) {
  let assert [x, y] =
    string.split(input, ",")
    |> list.map(fn(point) {
      int.parse(point)
      |> result.lazy_unwrap(fn() {
        panic as { "couldn't convert dimension " <> input <> " to int" }
      })
    })

  #(x, y)
}

fn set_grid_values(
  grid: Dict(#(Int, Int), Int),
  value: Int,
  start: #(Int, Int),
  end: #(Int, Int),
  curr: #(Int, Int),
) -> Dict(#(Int, Int), Int) {
  let grid =
    dict.upsert(grid, curr, fn(light_level) {
      case light_level {
        Some(light_level) -> light_level + value
        None -> value
      }
      |> int.max(0)
    })

  case curr {
    #(col, row) if col == end.0 && row == end.1 -> grid

    #(col, row) if col == end.0 ->
      set_grid_values(grid, value, start, end, #(start.0, row + 1))
    #(col, row) -> set_grid_values(grid, value, start, end, #(col + 1, row))
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
