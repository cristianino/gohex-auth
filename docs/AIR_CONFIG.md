# Air Configuration

This project includes two Air configuration files for different development environments.

## Configuration Files

### `.air.toml` - Local Development
- **Purpose**: Development on local machine
- **Polling**: Disabled (uses native file system events)
- **Delay**: 500ms rebuild delay
- **Logging**: Time disabled for cleaner output
- **Screen**: Keeps scroll history

### `.air.docker.toml` - Docker Development  
- **Purpose**: Development inside Docker containers
- **Polling**: Enabled (required for Docker volume mounting)
- **Delay**: 1000ms rebuild delay (slower for stability)
- **Logging**: Time enabled for debugging
- **Screen**: Clears on rebuild for cleaner Docker logs

## Usage

### Local Development
```bash
# Uses .air.toml
make dev-run
air
```

### Docker Development
```bash
# Uses .air.docker.toml automatically
make docker-dev
docker-compose up api-dev
```

## Key Differences

| Setting | Local (.air.toml) | Docker (.air.docker.toml) |
|---------|------------------|---------------------------|
| `poll` | false | true |
| `poll_interval` | 0 | 1000 |
| `delay` | 500 | 1000 |
| `log.time` | false | true |
| `screen.clear_on_rebuild` | false | true |
| `screen.keep_scroll` | true | false |

## Why Different Configurations?

### Docker Requirements
- **Polling**: Docker volume mounts don't always trigger native file system events
- **Longer delays**: Container I/O is slower than native file system
- **Clear screen**: Better experience in container logs
- **VCS disabled**: `-buildvcs=false` prevents Git-related build errors in containers

### Local Optimization  
- **Native events**: Faster and more efficient than polling
- **Shorter delays**: Native file system is faster
- **Scroll retention**: Better for interactive development

## Troubleshooting

### File Changes Not Detected in Docker
- Ensure `poll = true` in `.air.docker.toml`
- Check volume mounting: `- .:/usr/src/app`
- Verify file permissions

### Slow Rebuilds in Docker
- Increase `delay` and `poll_interval` values
- Use `.dockerignore` to exclude unnecessary files
- Ensure anonymous volume for `tmp` directory

### Performance Issues
- **Local**: Disable polling, reduce delays
- **Docker**: Enable polling, increase delays
- Exclude test files and vendor directories
