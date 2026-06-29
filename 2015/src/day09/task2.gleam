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

const path = "inputs/day09/input.txt"

fn task2() -> Nil {
  let #(locations, distances) =
    simplifile.read(path)
    |> result.lazy_unwrap(fn() { panic as { "Failed to read " <> path } })
    |> string.trim
    |> string.split("\n")
    |> list.map(string.split(_, " "))
    |> list.fold(#(set.from_list(["_"]), dict.new()), fn(acc, line) {
      let #(locations, distances) = acc
      case line {
        [loc1, "to", loc2, "=", distance] -> {
          let distance =
            int.parse(distance)
            |> result.lazy_unwrap(fn() {
              panic as { "Unable to parse distance " <> distance }
            })

          let locations = locations |> set.insert(loc1) |> set.insert(loc2)
          let distances =
            distances
            |> dict.insert(#(loc1, loc2), distance)
            |> dict.insert(#(loc2, loc1), distance)
            |> dict.insert(#("_", loc1), 0)
            |> dict.insert(#("_", loc2), 0)

          #(locations, distances)
        }
        _ -> panic as { "Unexpected line: " <> string.join(line, " ") }
      }
    })

  let locations = set.to_list(locations)
  let visited =
    list.map(locations, fn(location) { #(location, False) })
    |> dict.from_list

  let result =
    find_smallest_route(locations, distances, 0, "_", visited) |> int.to_string

  io.println(result)
}

fn find_smallest_route(
  locations: List(String),
  distances: Dict(#(String, String), Int),
  distance: Int,
  node: String,
  visited: Dict(String, Bool),
) -> Int {
  let visited = dict.insert(visited, node, True)
  let all_visited =
    dict.fold(visited, True, fn(prev_visited, _key, this_visited) {
      prev_visited && this_visited
    })
  case all_visited {
    False -> {
      list.filter_map(locations, fn(location) {
        case dict.get(visited, location) {
          Ok(False) -> {
            let distance_to_location =
              dict.get(distances, #(node, location))
              |> result.lazy_unwrap(fn() {
                panic as {
                  "Distance not found between " <> node <> " and " <> location
                }
              })
            let distance = distance + distance_to_location

            Ok(find_smallest_route(
              locations,
              distances,
              distance,
              location,
              visited,
            ))
          }
          Ok(True) -> Error(Nil)
          Error(_) -> panic as { "Location wasn't in visited: " <> location }
        }
      })
      |> list.max(int.compare)
      |> result.lazy_unwrap(fn() {
        panic as {
          "Distance list ended up being empty: "
          <> string.inspect(visited)
          <> "\n"
          <> string.inspect(distances)
        }
      })
    }
    True -> distance
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
