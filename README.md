# createapp

A simple utility to create macOS app bundles automatically.

## Usage

There are two methods for creating an app: you can either create a JSON file,
or create a test app by passing an executable file as an argument.

By default, `createapp` will search for a `.createapp.json` file. Check the
example `.createapp.json` file for reference.

### Example Usage

Passing an executable file as an argument:

```sh
createapp -m exec foo
```

Passing a JSON file as an argument:

```sh
createapp foo.json
```

You can clone this repository and do `swift run` in order to produce an
example application! Credits to [raylib](https://www.raylib.com/examples.html)
because I compiled their "Basic Window" example as an example executable.

## TODO

- [X] Better interface
- [X] Error messages (good enough)
- [ ] More configurability
- [ ] Include assets folders
