import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import gleam/time/duration
import gleam/time/timestamp
import simplifile

const path: String = "inputs/day21/input.txt"

type Stats {
  Stats(damage: Int, armor: Int)
}

type Equipment {
  Equipment(cost: Int, damage: Int, armor: Int)
}

const weapons: List(Equipment) = [
  // Dagger
  Equipment(cost: 8, damage: 4, armor: 0),
  // Shortsword
  Equipment(cost: 10, damage: 5, armor: 0),
  // Warhammer
  Equipment(cost: 25, damage: 6, armor: 0),
  // Longsword
  Equipment(cost: 40, damage: 7, armor: 0),
  // Greataxe
  Equipment(cost: 74, damage: 8, armor: 0),
]

const armors: List(Equipment) = [
  // None
  Equipment(cost: 0, damage: 0, armor: 0),
  // Leather
  Equipment(cost: 13, damage: 0, armor: 1),
  // Chainmail
  Equipment(cost: 31, damage: 0, armor: 2),
  // Splintmail
  Equipment(cost: 53, damage: 0, armor: 3),
  // Bandedmail
  Equipment(cost: 75, damage: 0, armor: 4),
  // Platemail
  Equipment(cost: 102, damage: 0, armor: 5),
]

const rings: List(Equipment) = [
  // Damage +1
  Equipment(cost: 25, damage: 1, armor: 0),
  // Damage +2
  Equipment(cost: 50, damage: 2, armor: 0),
  // Damage +3
  Equipment(cost: 100, damage: 3, armor: 0),
  // Defense +1
  Equipment(cost: 20, damage: 0, armor: 1),
  // Defense +2
  Equipment(cost: 40, damage: 0, armor: 2),
  // Defense +3
  Equipment(cost: 80, damage: 0, armor: 3),
]

fn task2() -> Nil {
  let rings =
    list.append([[]], list.map(rings, fn(ring) { [ring] }))
    |> list.append(list.combinations(rings, 2))

  let result =
    simplifile.read(path)
    |> result.lazy_unwrap(fn() { panic as { "Failed to read " <> path } })
    |> string.trim
    |> string.replace("\n", " ")
    |> string.split(" ")
    |> fn(input) {
      // HP for boss and player is equal in my input and the math is based on that
      let assert [_, _, _, _, damage, _, armor] = input
        as { "Incorrect input: " <> string.join(input, " ") }

      let assert [Ok(damage), Ok(armor)] = list.map([damage, armor], int.parse)

      Stats(damage, armor)
    }
    |> fn(boss_stats) {
      use max_cost, weapon <- list.fold(weapons, 0)
      use max_cost, armor <- list.fold(armors, max_cost)
      use max_cost, selected_rings <- list.fold(rings, max_cost)
      let player_stats =
        list.fold(
          selected_rings,
          Stats(weapon.damage, armor.armor),
          fn(stats, ring) {
            Stats(stats.damage + ring.damage, stats.armor + ring.armor)
          },
        )

      case
        calculate_damage(player_stats.damage, boss_stats.armor)
        < calculate_damage(boss_stats.damage, player_stats.armor)
      {
        True -> {
          let cost =
            { weapon.cost + armor.cost }
            + list.fold(selected_rings, 0, fn(cost, ring) { cost + ring.cost })

          int.max(cost, max_cost)
        }
        False -> max_cost
      }
    }
    |> int.to_string

  io.println(result)
}

fn calculate_damage(damage: Int, armor: Int) -> Int {
  int.max(1, damage - armor)
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
