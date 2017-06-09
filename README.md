# VeryVoting

## Deps
* [Elixir](https://elixir-lang.org/install.html)
* [Elm](https://guide.elm-lang.org/install.html#install)
* [elm-github-install](https://github.com/gdotdesign/elm-github-install)

## To start in Dev
1. `cd` to the root of the umbrella app
2. Add .env file and run `source .env`
3. `mix deps.get`
4. `cd apps/voting_web/web/elm/`
5. `elm-install`
6. `rm -rf elm-stuff/packages/saschatimme/elm-phoenix/1.0.0/example/`
7. `cd ../../../../`
8. `mix phoenix.server`

## Testing
1. `cd` to the root of the umbrella app
2. `mix test`
