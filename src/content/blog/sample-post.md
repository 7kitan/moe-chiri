---
title: Writing a Markov Chain in OCaml
pubDate: '2026-06-15'
tags: [ocaml, tutorial, algorithms]
---

A Markov chain generates text by picking the next word based on the previous *n* words (the order). This tutorial builds a second-order chain — each state is a pair of words, and we predict what comes next.

## Representing the State

We'll use a map from 2-word prefixes to a distribution of possible next words. A `string list` tracks how many times each suffix follows a given prefix.

```ocaml
type prefix = string * string

module PrefixMap = Map.Make (struct
  type t = prefix
  let compare = compare
end)

let chain : string list PrefixMap.t ref = ref PrefixMap.empty
```

## Training on a Corpus

Split the text into words, slide a window of three, and record each `(a, b) -> c` relationship.

```ocaml
let train words =
  let rec loop a b = function
    | c :: rest ->
      let k = (a, b) in
      let cur = Option.value ~default:[] (PrefixMap.find_opt k !chain) in
      chain := PrefixMap.add k (c :: cur) !chain;
      loop b c rest
    | [] -> ()
  in
  match words with
  | a :: b :: rest -> loop a b rest
  | _ -> ()
```

Each call to `train` pushes `c` onto the list for prefix `(a, b)`. Duplicates are fine — they encode relative frequency.

## Generating Text

Pick a random starting pair, then repeatedly draw the next word from the distribution of its prefix.

```ocaml
let random_suffix k =
  match PrefixMap.find_opt k !chain with
  | None -> None
  | Some suffixes ->
    let i = Random.int (List.length suffixes) in
    Some (List.nth suffixes i)

let generate start_a start_b len =
  let rec loop a b n acc =
    if n = 0 then List.rev acc
    else
      match random_suffix (a, b) with
      | None -> List.rev acc
      | Some c -> loop b c (n - 1) (c :: acc)
  in
  loop start_a start_b len [start_a; start_b]
```

## Putting It Together

```ocaml
let () =
  Random.self_init ();
  let text = "the cat sat on the mat the cat ate the mouse" in
  let words = String.split_on_char ' ' text in
  train words;
  let output = generate "the" "cat" 10 in
  print_endline (String.concat " " output)
```

Run with `ocaml` and you'll get a sentence seeded by "the cat" that follows the patterns of the training data.

## Extensions

- **Higher order** — use `string list` as the prefix key instead of `string * string`.
- **Smoothing** —-add a small uniform probability for unseen prefixes.
- **End-of-sentence tokens** — treat punctuation as tokens so the model learns sentence boundaries.
- **Persistent storage** — marshal the `chain` map to disk so you can reuse a trained model.
