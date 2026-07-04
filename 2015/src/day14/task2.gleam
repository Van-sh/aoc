import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{Some, None}
import gleam/result
import gleam/string
import gleam/time/duration
import gleam/time/timestamp
import simplifile

const path: String = "inputs/day14/input.txt"

const total_time: Int = 2503

type Reindeer {
  Reindeer(name: String, speed: Int, runtime: Int, rest_time: Int)
}

fn task2() -> Nil {
  let reindeers =
    simplifile.read(path)
    |> result.lazy_unwrap(fn() { panic as { "Failed to read " <> path } })
    |> string.trim
    |> string.split("\n")
    |> list.map(string.split(_, " "))
    |> list.map(fn(line) {
      case line {
        [name, _, _, speed, _, _, runtime, _, _, _, _, _, _, rest_time, _] -> {
          let assert [speed, runtime, rest_time] =
            [speed, runtime, rest_time]
            |> list.map(fn(val) {
              int.parse(val)
              |> result.lazy_unwrap(fn() {
                panic as { "Couldn't parse " <> val }
              })
            })
          Reindeer(name, speed, runtime, rest_time)
        }
        _ -> panic as { "Unexpected line: " <> string.join(line, " ") }
      }
    })

  let result =
    int.range(1, total_time + 1, dict.new(), fn(points, t) {
      let distances =
        list.map(reindeers, fn(reindeer) {
          let time_period = reindeer.runtime + reindeer.rest_time

          #(
            reindeer.name,
            { t / time_period * reindeer.speed * reindeer.runtime }
              + { int.min(t % time_period, reindeer.runtime) * reindeer.speed },
          )
        })

      let max =
        list.max(distances, fn(first, second) { int.compare(first.1, second.1) })
        |> result.lazy_unwrap(fn() { panic as "Couldn't find max" })
      list.filter(distances, fn(reindeer_score) { reindeer_score.1 == max.1 })
      |> list.fold(points, fn(points, leader) {
        dict.upsert(points, leader.0, fn(value) {
          case value {
            Some(i) -> i + 1
            None -> 1
          }
        })
      })
    })
    |> dict.to_list
    |> list.max(fn(first, second) { int.compare(first.1, second.1) })
    |> result.lazy_unwrap(fn() { panic })
    |> fn(score) { score.1 }
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
    <> int.to_string(nanoseconds)
    <> "ns",
  )
}
