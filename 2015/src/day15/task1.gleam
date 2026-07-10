import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import gleam/time/duration
import gleam/time/timestamp
import simplifile

const path: String = "inputs/day15/input.txt"

const max_ingredients: Int = 100

type Ingredient {
  Ingredient(capacity: Int, durability: Int, flavor: Int, texture: Int)
}

fn task1() -> Nil {
  let result =
    simplifile.read(path)
    |> result.lazy_unwrap(fn() { panic as { "Failed to read " <> path } })
    |> string.trim
    |> string.split("\n")
    |> list.map(fn(line) {
      let assert [_name, details] = string.split(line, ": ")
      details
    })
    |> list.map(fn(ingredient) {
      let assert [capacity, durability, flavor, texture, _calories] =
        string.split(ingredient, ", ")
        |> list.map(fn(property) {
          let assert [name, value] = string.split(property, " ")

          int.parse(value)
          |> result.lazy_unwrap(fn() {
            panic as { "Couldn't parse " <> name <> ": " <> value }
          })
        })

      Ingredient(capacity, durability, flavor, texture)
    })
    |> search_space(0)
    |> list.map(fn(combination) {
      let combination =
        list.fold(combination, Ingredient(0, 0, 0, 0), fn(acc, ingredient) {
          Ingredient(
            acc.capacity + ingredient.capacity,
            acc.durability + ingredient.durability,
            acc.flavor + ingredient.flavor,
            acc.texture + ingredient.texture,
          )
        })

      Ingredient(
        int.max(0, combination.capacity),
        int.max(0, combination.durability),
        int.max(0, combination.flavor),
        int.max(0, combination.texture),
      )
    })
    |> list.fold(0, fn(max, cookie) {
      let cookie =
        cookie.capacity * cookie.durability * cookie.flavor * cookie.texture

      case max > cookie {
        True -> max
        False -> cookie
      }
    })
    |> int.to_string

  io.println(result)
}

fn search_space(
  ingredients: List(Ingredient),
  ingredient_count: Int,
) -> List(List(Ingredient)) {
  case ingredients {
    [ingredient] -> {
      let count = max_ingredients - ingredient_count
      [
        [
          Ingredient(
            ingredient.capacity * count,
            ingredient.durability * count,
            ingredient.flavor * count,
            ingredient.texture * count,
          ),
        ],
      ]
    }
    [ingredient, ..ingredients] -> {
      use space, count <- int.range(
        0,
        max_ingredients - ingredient_count + 1,
        [],
      )

      list.append(
        space,
        search_space(ingredients, ingredient_count + count)
          |> list.map(fn(state) {
            [
              Ingredient(
                ingredient.capacity * count,
                ingredient.durability * count,
                ingredient.flavor * count,
                ingredient.texture * count,
              ),
              ..state
            ]
          }),
      )
    }
    _ -> panic
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
    <> int.to_string(nanoseconds) |> string.pad_start(9, "0")
    <> "ns",
  )
}
