import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/option
import gleam/result
import gleam/string
import gleam/time/duration
import gleam/time/timestamp
import simplifile

const path = "inputs/day06/input.txt"

type ToggleOrSetLight {
  SetLight(Bool)
  ToggleLight
}

fn task1() -> Nil {
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
            "on" -> SetLight(True)
            "off" -> SetLight(False)
            _ -> panic as { "unexpected mode: " <> mode }
          }

          set_grid_values(grid, value, start, end, start)
        }
        ["toggle", start, "through", end] -> {
          let start = extract_coord_from_string(start)
          let end = extract_coord_from_string(end)
          let value = ToggleLight

          set_grid_values(grid, value, start, end, start)
        }
        _ -> panic as { "unexpected sentence: " <> string.join(line, " ") }
      }
    })
    |> dict.fold(0, fn(acc, _key, value) {
      case value {
        True -> acc + 1
        False -> acc
      }
    })
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
  grid: dict.Dict(#(Int, Int), Bool),
  value: ToggleOrSetLight,
  start: #(Int, Int),
  end: #(Int, Int),
  curr: #(Int, Int),
) -> dict.Dict(#(Int, Int), Bool) {
  let grid =
    dict.upsert(grid, curr, fn(light_lit) {
      case light_lit {
        option.Some(light_lit) ->
          case value {
            ToggleLight -> !light_lit
            SetLight(value) -> value
          }
        option.None ->
          case value {
            SetLight(False) -> False
            _ -> True
          }
      }
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

  task1()

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
