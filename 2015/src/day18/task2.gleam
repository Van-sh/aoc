import gleam/dict.{type Dict}
import gleam/float
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import gleam/time/duration
import gleam/time/timestamp
import simplifile

const path: String = "inputs/day18/input.txt"

const steps: Int = 100

fn task2() -> Nil {
  let result =
    simplifile.read(path)
    |> result.lazy_unwrap(fn() { panic as { "Failed to read " <> path } })
    |> string.trim
    |> string.split("\n")
    |> list.index_fold(dict.new(), fn(grid, line, row) {
      make_grid_row(grid, line, row, 0)
    })
    |> turn_on_corners
    |> animate_frames(steps)
    |> turn_on_corners
    |> dict.fold(0, fn(acc, _, is_on) {
      case is_on {
        True -> acc + 1
        False -> acc
      }
    })
    |> int.to_string

  io.println(result)
}

fn turn_on_corners(grid: Dict(#(Int, Int), Bool)) -> Dict(#(Int, Int), Bool) {
  let grid_width =
    dict.size(grid)
    |> int.square_root
    |> result.lazy_unwrap(fn() {
      panic as "Expected grid to be a perfect square"
    })
    |> float.truncate

  grid
  |> dict.insert(#(0, 0), True)
  |> dict.insert(#(0, grid_width - 1), True)
  |> dict.insert(#(grid_width - 1, 0), True)
  |> dict.insert(#(grid_width - 1, grid_width - 1), True)
}

fn animate_frames(
  grid: Dict(#(Int, Int), Bool),
  iterations: Int,
) -> Dict(#(Int, Int), Bool) {
  case iterations {
    0 -> grid
    _ -> {
      dict.map_values(grid, fn(pos, is_on) {
        let on_neighbours = {
          use on_neighbours, row <- int.range(pos.0 - 1, pos.0 + 2, 0)

          use on_neighbours, col <- int.range(
            pos.1 - 1,
            pos.1 + 2,
            on_neighbours,
          )

          case
            dict.get(grid, #(row, col)) |> result.unwrap(False)
            && { row != pos.0 || col != pos.1 }
          {
            True -> on_neighbours + 1
            False -> on_neighbours
          }
        }

        case is_on, on_neighbours {
          True, 2 | _, 3 -> True
          _, _ -> False
        }
      })
      |> turn_on_corners
      |> animate_frames(iterations - 1)
    }
  }
}

fn make_grid_row(
  grid: Dict(#(Int, Int), Bool),
  line: String,
  row: Int,
  col: Int,
) -> Dict(#(Int, Int), Bool) {
  case line {
    "" -> grid
    "#" <> rest ->
      dict.insert(grid, #(row, col), True) |> make_grid_row(rest, row, col + 1)
    "." <> rest ->
      dict.insert(grid, #(row, col), False) |> make_grid_row(rest, row, col + 1)
    _ -> panic as { "unexpected line: " <> line }
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
    <> int.to_string(nanoseconds) |> string.pad_start(9, "0")
    <> "ns",
  )
}
