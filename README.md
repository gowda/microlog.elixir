# MicroLog

![](https://github.com/gowda/microlog.elixir/workflows/credo/badge.svg)
![](https://github.com/gowda/microlog.elixir/workflows/test/badge.svg)

Implementation of [`sample_app`](https://github.com/mhartl/sample_app_3rd_edition) from [Ruby on Rails Tutorial (3rd Ed.)](https://3rd-edition.railstutorial.org/book) using [`phoenix`](https://www.phoenixframework.org/).

## Development
### Install dependencies
```bash
$ mix deps.get
$ mix ecto.setup
$ npm --prefix=assets install
```

### Start server
```bash
$ mix phx.server
```

Server runs at [`localhost:4000`](http://localhost:4000)
