# Pomidor

A TUI (Terminal User Interface) Pomodoro timer written in D.

## Features

- Countdown on work - rest - work - long rest cycles
- Big rendered clock in the TUI with visual timer countdown
- Notifications (via libnotify or ntfy) when cycles complete
- Keyboard controls for navigation

## Installation

### Prerequisites

- D compiler (dmd, ldc2, or gdc)
- libnotify (for desktop notifications)
- libcaca (for TUI rendering)

### Building

```bash
dub build
```

## Configuration

Create a configuration file at `~/.config/pomidor/config.sdl`.

Required fields: `type` and `split`. The `split` field controls the timer duration (`short` or `long`). Optional: `enable_long_rest` (defaults to false).

### Using ntfy notifications:

```
type "ntfy"
split "short"
ntfy {
  url "https://ntfy.sh"
  topic "your-topic"
  token "your-token"
}
```

Or using a token file:

```
type "ntfy"
split "short"
ntfy {
  url "https://ntfy.sh"
  topic "your-topic"
  token_file "/path/to/token/file"
}
```

### Using native desktop notifications:

```
type "native"
split "short"
```

This will use libnotify for desktop notifications without any additional configuration.

## Usage

Run the application:
```bash
./pomidor
```

## Running Tests

To run the test suite:

```bash
dub test
```

## Development

## License

MIT License - see [LICENSE](LICENSE) for details.
