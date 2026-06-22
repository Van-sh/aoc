import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import gleam/time/duration
import gleam/time/timestamp
import simplifile

const path = "inputs/day11/input.txt"

const blacklisted_chars = ["i", "o", "l"]

fn task1() -> Nil {
  let result =
    simplifile.read(path)
    |> result.lazy_unwrap(fn() { panic as { "Failed to read " <> path } })
    |> string.trim
    |> string.to_utf_codepoints
    |> encode_base_26(0)
    |> find_next_password
    |> find_next_password
    |> decode_base_26([])
    |> string.from_utf_codepoints
    // a is basically leading zeroes
    |> string.pad_start(8, "a")

  io.println(result)
}

fn find_next_password(prev_password: Int) -> Int {
  let password = prev_password + 1

  case is_valid_password(password) {
    False -> {
      find_next_password(password)
    }
    True -> password
  }
}

fn is_valid_password(password: Int) -> Bool {
  let password_codepoints = decode_base_26(password, [])
  let password_str = string.from_utf_codepoints(password_codepoints)

  must_include_one_increasing_straight_of_atleast_three_characters(
    password_codepoints,
  )
  && must_not_include_blacklisted_characters(password_str)
  && must_contain_non_overlapping_pairs_of_chars(password_codepoints, 2)
}

fn must_include_one_increasing_straight_of_atleast_three_characters(
  password: List(UtfCodepoint),
) -> Bool {
  case password {
    [first, second, third, ..rest] -> {
      let assert [first_ord, second_ord, third_ord] =
        list.map([first, second, third], string.utf_codepoint_to_int)
      case first_ord == second_ord - 1, second_ord == third_ord - 1 {
        True, True -> True
        _, _ ->
          must_include_one_increasing_straight_of_atleast_three_characters([
            second,
            third,
            ..rest
          ])
      }
    }
    [_, ..rest] ->
      must_include_one_increasing_straight_of_atleast_three_characters(rest)
    [] -> False
  }
}

fn must_not_include_blacklisted_characters(password: String) -> Bool {
  !list.any(blacklisted_chars, fn(char) { string.contains(password, char) })
}

fn must_contain_non_overlapping_pairs_of_chars(
  password: List(UtfCodepoint),
  count: Int,
) -> Bool {
  case count {
    0 -> True
    _ -> {
      case password {
        [first, second, ..rest] if first == second ->
          must_contain_non_overlapping_pairs_of_chars(rest, count - 1)
        [_, ..rest] -> must_contain_non_overlapping_pairs_of_chars(rest, count)
        [] -> False
      }
    }
  }
}

fn encode_base_26(input: List(UtfCodepoint), value: Int) -> Int {
  case input {
    [char, ..rest] -> {
      let char_pos =
        string.utf_codepoint_to_int(char)
        |> int.bitwise_and(31)
        |> int.subtract(1)
      let value = value * 26 + char_pos
      encode_base_26(rest, value)
    }
    [] -> value
  }
}

fn decode_base_26(
  input: Int,
  codepoints: List(UtfCodepoint),
) -> List(UtfCodepoint) {
  case input {
    0 -> codepoints
    _ -> {
      let char_pos = input % 26 + 1 |> int.bitwise_or(96)
      let input = input / 26

      case string.utf_codepoint(char_pos) {
        Ok(codepoint) -> decode_base_26(input, [codepoint, ..codepoints])
        Error(_) ->
          panic as { "Couldn't decode char " <> int.to_string(char_pos) }
      }
    }
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
