# Pomidor

A TUI (Terminal User Interface) Pomodoro timer written in D.

## Features

- Countdown on work - rest - work - long rest cycles
- Big rendered clock in the TUI with visual timer countdown
- Desktop notifications (via libnotify) when cycles complete
- Keyboard controls for navigation (n for next, q for quit)

## Installation

### Prerequisites

- D compiler (dmd, ldc2, or gdc)
- libnotify (for desktop notifications) - **required**
- libcaca (for TUI rendering)

#### Installing dependencies

On NixOS:
```bash
nix-shell -p dmd libnotify caca
```

On Ubuntu/Debian:
```bash
sudo apt install dmd libnotify-dev libcaca-dev
```

On Arch Linux:
```bash
sudo pacman -S dmd libnotify libcaca
```

On macOS:
```bash
brew install dmd libnotify libcaca
```

### Building

```bash
dub build --config=application
```

Or simply:
```bash
dub build
```

## Configuration

Create a configuration file at `~/.config/pomidor/config.toml`:

```toml
[ntfy]
url = "https://ntfy.sh"
topic = "your-topic"
token = "your-token"
```

Note: The ntfy configuration is currently unused as the application now uses desktop notifications via libnotify. Future versions may support both notification methods.

## Usage

Run the application:
```bash
./pomidor
```

### Controls

- `n` - Skip to next phase
- `q` - Quit the application

## Timer Cycles

The Pomodoro technique consists of the following cycles:

1. **Work**: 25 minutes
2. **Rest**: 5 minutes
3. **Work**: 25 minutes
4. **Rest**: 5 minutes
... (repeat)

Every 8 work periods, a long rest of 25 minutes is taken instead of the regular rest.

## Running Tests

To run the test suite:

```bash
dub test
```

Note: Tests require libnotify to be installed on the system.

## Development

### Project Structure

```
pomidor/
├── source/
│   ├── main.d           # Application entry point
│   ├── app.d            # Main application logic
│   ├── config.d         # Configuration parsing
│   ├── notification.d   # Notification handling (libnotify)
│   ├── terminal.d       # TUI rendering with libcaca
│   ├── timings.d        # Timer constants
│   ├── utils.d          # Utility functions
│   └── caca.d           # libcaca bindings
├── tests/
│   ├── test.d           # Test suite
│   └── dub.sdl          # Test configuration
├── dub.sdl              # DUB configuration
└── README.md            # This file
```

### Stack

- **Language**: D
- **TUI**: libcaca
- **Notifications**: libnotify-d
- **Config**: toml-d

## License

MIT License - see [LICENSE](LICENSE) for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Roadmap

- [ ] Add pausing functionality
- [ ] Support for custom timer durations in config
- [ ] Support for both ntfy and libnotify notifications
- [ ] Raylib-based rendering option
- [ ] Multi-architecture build support
