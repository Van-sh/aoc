import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import gleam/time/duration
import gleam/time/timestamp
import simplifile

const path: String = "inputs/day22/input.txt"

type Boss {
  Boss(hp: Int, damage: Int)
}

type Player {
  Player(hp: Int, mana: Int)
}

type Spells {
  // Magic Missile costs 53 mana. It instantly does 4 damage.
  MagicMissile
  // Drain costs 73 mana. It instantly does 2 damage and heals you for 2 hit points.
  Drain
  // Shield costs 113 mana. It starts an effect that lasts for 6 turns. While it is active, your armor is increased by 7.
  Shield
  // Poison costs 173 mana. It starts an effect that lasts for 6 turns. At the start of each turn while it is active, it deals the boss 3 damage.
  Poison
  // Recharge costs 229 mana. It starts an effect that lasts for 5 turns. At the start of each turn while it is active, it gives you 101 new mana.
  Recharge
}

const spells = [
  MagicMissile,
  Drain,
  Shield,
  Poison,
  Recharge,
]

const magic_missile_damage = 4

const magic_missile_mana_cost = 53

const drain_damage = 2

const drain_mana_cost = 73

const shield_armor = 7

const shield_mana_cost = 113

const poison_damage = 3

const poison_mana_cost = 173

const recharge_mana = 101

const recharge_mana_cost = 229

type EffectTimers {
  EffectTimers(shield: Int, poison: Int, recharge: Int)
}

const shield_duration = 6

const poison_duration = 6

const recharge_duration = 5

fn task2() -> Nil {
  let result =
    simplifile.read(path)
    |> result.lazy_unwrap(fn() { panic as { "Failed to read " <> path } })
    |> string.trim
    |> string.replace("\n", " ")
    |> string.split(" ")
    |> fn(input) {
      let assert [_, _, hp, _, damage] = input
        as { "Incorrect input: " <> string.join(input, " ") }

      let assert [Ok(hp), Ok(damage)] = list.map([hp, damage], int.parse)

      Boss(hp, damage)
    }
    |> solve(Player(50, 500), 1_000_000_000_000, 0, EffectTimers(0, 0, 0), True)
    |> string.inspect

  io.println(result)
}

fn solve(
  boss: Boss,
  player: Player,
  min_mana: Int,
  total_mana_spent: Int,
  effect_timers: EffectTimers,
  is_players_turn: Bool,
) -> Int {
  let player = case is_players_turn {
    True -> Player(..player, hp: player.hp - 1)
    False -> player
  }

  case total_mana_spent > min_mana || player.hp <= 0 {
    True -> min_mana
    False -> {
      let #(effect_timers, player) = case effect_timers.recharge > 0 {
        False -> #(effect_timers, player)
        True -> {
          #(
            EffectTimers(..effect_timers, recharge: effect_timers.recharge - 1),
            Player(..player, mana: player.mana + recharge_mana),
          )
        }
      }
      let #(effect_timers, player_armor) = case effect_timers.shield > 0 {
        False -> #(effect_timers, 0)
        True -> #(
          EffectTimers(..effect_timers, shield: effect_timers.shield - 1),
          shield_armor,
        )
      }
      let #(effect_timers, boss) = case effect_timers.poison > 0 {
        False -> #(effect_timers, boss)
        True -> #(
          EffectTimers(..effect_timers, poison: effect_timers.poison - 1),
          Boss(..boss, hp: boss.hp - poison_damage),
        )
      }

      case boss.hp <= 0, is_players_turn {
        True, _ -> int.min(min_mana, total_mana_spent)
        False, False -> {
          let player =
            Player(..player, hp: player.hp - boss.damage + player_armor)
          case player.hp > 0 {
            False -> min_mana
            True ->
              solve(
                boss,
                player,
                min_mana,
                total_mana_spent,
                effect_timers,
                True,
              )
          }
        }
        False, True -> {
          use min_mana, spell <- list.fold(spells, min_mana)
          case spell {
            MagicMissile ->
              case player.mana <= magic_missile_mana_cost {
                True -> min_mana
                False ->
                  solve(
                    Boss(..boss, hp: boss.hp - magic_missile_damage),
                    Player(
                      ..player,
                      mana: player.mana - magic_missile_mana_cost,
                    ),
                    min_mana,
                    total_mana_spent + magic_missile_mana_cost,
                    effect_timers,
                    False,
                  )
                  |> int.min(min_mana)
              }
            Drain ->
              case player.mana <= drain_mana_cost {
                True -> min_mana
                False ->
                  solve(
                    Boss(..boss, hp: boss.hp - drain_damage),
                    Player(
                      player.hp + drain_damage,
                      player.mana - drain_mana_cost,
                    ),
                    min_mana,
                    total_mana_spent + drain_mana_cost,
                    effect_timers,
                    False,
                  )
                  |> int.min(min_mana)
              }
            Shield ->
              case effect_timers.shield > 0 || player.mana <= shield_mana_cost {
                True -> min_mana
                False ->
                  solve(
                    boss,
                    Player(..player, mana: player.mana - shield_mana_cost),
                    min_mana,
                    total_mana_spent + shield_mana_cost,
                    EffectTimers(..effect_timers, shield: shield_duration),
                    False,
                  )
                  |> int.min(min_mana)
              }
            Poison ->
              case effect_timers.poison > 0 || player.mana <= poison_mana_cost {
                True -> min_mana
                False ->
                  solve(
                    boss,
                    Player(..player, mana: player.mana - poison_mana_cost),
                    min_mana,
                    total_mana_spent + poison_mana_cost,
                    EffectTimers(..effect_timers, poison: poison_duration),
                    False,
                  )
                  |> int.min(min_mana)
              }
            Recharge ->
              case
                effect_timers.recharge > 0 || player.mana <= recharge_mana_cost
              {
                True -> min_mana
                False ->
                  solve(
                    boss,
                    Player(..player, mana: player.mana - recharge_mana_cost),
                    min_mana,
                    total_mana_spent + recharge_mana_cost,
                    EffectTimers(..effect_timers, recharge: recharge_duration),
                    False,
                  )
                  |> int.min(min_mana)
              }
          }
        }
      }
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
    <> int.to_string(nanoseconds) |> string.pad_start(9, "0")
    <> "ns",
  )
}
