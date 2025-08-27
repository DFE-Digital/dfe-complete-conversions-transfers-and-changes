## Running the application with Docker (Windows development)

This guide shows how to run the Rails app in Docker on a Windows host while editing code locally in VS Code.

### Overview

This project provides a Docker-based development environment optimized for Windows:

* `Dockerfile` - Multi-stage, production-ready build
* `docker-compose.yml` - Backing services: SQL Server, Redis, Redis Insight  
* `docker-compose.dev.yml` - Development overlay with `app`, `sidekiq`, and `js` services using performant volume strategy for Windows

### Prerequisites

**Required:**
* Windows 10/11 with Docker Desktop
* Docker Desktop configured to use WSL2 backend (strongly recommended)
* Git for Windows
* VS Code

**Recommended:**
* WSL2 distro (e.g., Ubuntu) for better Git and file I/O performance
* VS Code extensions: Docker, Ruby, Remote-Containers

**Verify Prerequisites:**
```powershell
# Check Docker version and WSL2 backend
docker version
docker info | Select-String "WSL"

# Check WSL2 (optional but recommended)
wsl --list --verbose
```

### First time setup

1. **Set up environment files:**
   ```powershell
   # Copy environment templates
   Copy-Item .env.example .env.development.local -ErrorAction SilentlyContinue
   Copy-Item .env.database.example .env.database.local -ErrorAction SilentlyContinue
   ```

2. **Configure database password:**
   Set a strong SA password in `.env.database.local` or `.env.database`:
   ```
   MSSQL_SA_PASSWORD=YourStr0ngP@ssw0rd!
   ```
   > **Note:** Password must be at least 8 characters with uppercase, lowercase, numbers, and symbols.

3. **(Optional) Configure other environment variables:**
   Edit `.env.development.local` if you need to customize:
   - `DATABASE_HOST=localhost` (for direct host connection)
   - `AZURE_*` variables (for authentication features)
   - `GOV_NOTIFY_API_KEY` (for notifications)
   
   > **Tip:** The Docker setup uses sensible defaults, so you typically only need the database password.

4. **Build and start all services:**
   ```powershell
   docker compose -f docker-compose.yml -f docker-compose.dev.yml up --build
   ```

5. **Verify the setup:**
   - App: http://localhost:3000
   - Health check: http://localhost:3000/healthcheck  
   - Redis Insight: http://localhost:5540

**First run takes 5-10 minutes** to build images and install dependencies.

### Common commands (development)

```powershell
# Start all services (detached mode)
docker compose -f docker-compose.yml -f docker-compose.dev.yml up -d

# Build images (after Gemfile/package.json changes)
docker compose -f docker-compose.yml -f docker-compose.dev.yml build

# View logs (all services)
docker compose -f docker-compose.yml -f docker-compose.dev.yml logs -f

# View logs (specific service)
docker compose -f docker-compose.yml -f docker-compose.dev.yml logs -f app
docker compose -f docker-compose.yml -f docker-compose.dev.yml logs -f sidekiq

# Run one-off commands
docker compose -f docker-compose.yml -f docker-compose.dev.yml run --rm app bin/rails console
docker compose -f docker-compose.yml -f docker-compose.dev.yml run --rm app bin/rspec
docker compose -f docker-compose.yml -f docker-compose.dev.yml run --rm app bin/rails db:migrate

# Stop all services
docker compose -f docker-compose.yml -f docker-compose.dev.yml down

# Stop and remove ALL data (database, Redis, gems, node_modules)
docker compose -f docker-compose.yml -f docker-compose.dev.yml down -v
```

### Dependency management

**How it works:**
- Named volumes (`dfe-complete_bundle`, `dfe-complete_node_modules`) store dependencies in the Linux filesystem (faster than Windows bind mounts)
- Source code is bind-mounted for instant edits
- Volumes persist between container restarts

**Clean dependency cache:**
```powershell
# Stop services
docker compose -f docker-compose.yml -f docker-compose.dev.yml down

# Remove dependency volumes
docker volume rm dfe-complete_bundle dfe-complete_node_modules 2>$null

# Rebuild with fresh dependencies
docker compose -f docker-compose.yml -f docker-compose.dev.yml up --build
```

**Update dependencies:**
```powershell
# After changing Gemfile
docker compose -f docker-compose.yml -f docker-compose.dev.yml build app

# After changing package.json  
docker compose -f docker-compose.yml -f docker-compose.dev.yml build js
```

### Database operations

**Automatic setup:**
The startup command runs `bin/rails db:prepare` automatically.

**Manual database tasks:**
```powershell
# Reset database completely
docker compose -f docker-compose.yml -f docker-compose.dev.yml run --rm app bin/rails db:drop db:create db:migrate

# Run migrations
docker compose -f docker-compose.yml -f docker-compose.dev.yml run --rm app bin/rails db:migrate

# Seed database
docker compose -f docker-compose.yml -f docker-compose.dev.yml run --rm app bin/rails db:seed

# Database console
docker compose -f docker-compose.yml -f docker-compose.dev.yml run --rm app bin/rails dbconsole
```

**Database connection issues:**
If SQL Server fails to start, try:
```powershell
# Remove database volume and restart
docker compose -f docker-compose.yml -f docker-compose.dev.yml down
docker volume rm dfe-complete_sql-server-data
docker compose -f docker-compose.yml -f docker-compose.dev.yml up -d db
```

### Running tests

**Option 1: Ad-hoc tests (recommended)**
```powershell
# Run all tests
docker compose -f docker-compose.yml -f docker-compose.dev.yml run --rm `
  -e RAILS_ENV=test `
  -e DATABASE_HOST=db `
  app bash -lc "bin/rails db:prepare && bin/rspec"

# Run specific test file
docker compose -f docker-compose.yml -f docker-compose.dev.yml run --rm `
  -e RAILS_ENV=test `
  -e DATABASE_HOST=db `
  app bin/rspec spec/models/user_spec.rb

# Run with coverage
docker compose -f docker-compose.yml -f docker-compose.dev.yml run --rm `
  -e RAILS_ENV=test `
  -e DATABASE_HOST=db `
  app bash -lc "bin/rails db:prepare && bin/rspec --format documentation"
```

**Option 2: Test-specific compose file**
```powershell
# Use the test compose file for isolated testing
docker compose -f docker-compose.yml -f docker-compose.checks.yml run --rm app bin/rspec
```

### Debugging with rdbg

**Setup:**
1. Set the debug environment variable:
   ```powershell
   $env:RUBY_DEBUG_OPEN = "true"
   ```

2. **Option A:** Restart services with debug enabled
   ```powershell
   docker compose -f docker-compose.yml -f docker-compose.dev.yml down
   docker compose -f docker-compose.yml -f docker-compose.dev.yml up -d
   ```

3. **Option B:** Run server manually with debug
   ```powershell
   docker compose -f docker-compose.yml -f docker-compose.dev.yml exec app bash -lc "RUBY_DEBUG_OPEN=true bin/rails server -b 0.0.0.0"
   ```

**VS Code configuration:**
Add to `.vscode/launch.json`:
```json
{
  "name": "Attach to Docker Rails (rdbg)",
  "type": "rdbg", 
  "request": "attach",
  "localfs": true,
  "remotePort": 12345,
  "remoteHost": "localhost"
}
```

**Usage:**
- Add `debugger` statements in your Ruby code
- Use VS Code's "Run and Debug" panel to attach
- Set breakpoints in VS Code

### Live asset rebuilding

**Automatic (included in dev setup):**
The `js` service automatically runs `yarn build --watch` to rebuild assets on changes.

**Manual asset building:**
```powershell
# Check asset build status
docker compose -f docker-compose.yml -f docker-compose.dev.yml logs -f js

# Rebuild assets manually
docker compose -f docker-compose.yml -f docker-compose.dev.yml exec js yarn build

# Enable polling for file changes (Windows)
# Option A: Set globally and restart watcher service
$env:FORCE_POLLING = "1"
docker compose -f docker-compose.yml -f docker-compose.dev.yml restart js

# Option B: One-off watch with polling
docker compose -f docker-compose.yml -f docker-compose.dev.yml exec js bash -lc "FORCE_POLLING=1 yarn build --watch"
```

### Redis Insight

Redis Insight provides a GUI for Redis debugging and monitoring.

**Access:** http://localhost:5540

**Setup:**
1. Open Redis Insight in browser
2. Add database connection:
   - Host: `redis` (or `localhost` if connecting from host)
   - Port: `6379`
   - Name: `DfE Complete Redis`

**Troubleshooting:**
```powershell
# Check Redis service status
docker compose -f docker-compose.yml -f docker-compose.dev.yml ps redis

# View Redis logs  
docker compose -f docker-compose.yml -f docker-compose.dev.yml logs redis

# Connect to Redis CLI
docker compose -f docker-compose.yml -f docker-compose.dev.yml exec redis redis-cli
```

### Windows-specific optimizations

**Performance tips:**
- ✅ Use WSL2 backend (not legacy Hyper-V)
- ✅ Store heavy I/O in volumes (`bundle`, `node_modules`, `tmp`, `log`)
- ✅ Use LF line endings (enforced by `.gitattributes`)
- ✅ Exclude Docker volumes from antivirus real-time scanning

**Git configuration:**
```powershell
# Ensure consistent line endings
git config core.autocrlf input
```



**Antivirus exclusions:**
Add these paths to antivirus exclusions for better performance:
- `%USERPROFILE%\.docker\`
- Docker volume storage location
- Your project directory (if using bind mounts)

### Health checks and monitoring

**Application health:**
```powershell
# Check health endpoint
curl http://localhost:3000/healthcheck

# View service status
docker compose -f docker-compose.yml -f docker-compose.dev.yml ps

# Check container health
docker inspect dfe-complete-app-1 --format='{{.State.Health.Status}}'
```

**Resource monitoring:**
```powershell
# View resource usage
docker stats

# Check logs for errors
docker compose -f docker-compose.yml -f docker-compose.dev.yml logs --tail=50 app
```

### Cleaning up

**Stop services:**
```powershell
# Stop all services
docker compose -f docker-compose.yml -f docker-compose.dev.yml down

# Stop and remove volumes (clears all data!)
docker compose -f docker-compose.yml -f docker-compose.dev.yml down -v
```

**Clean Docker system:**
```powershell
# Remove unused images, containers, networks
docker system prune -f

# Remove unused volumes (careful!)
docker system prune --volumes -f

# Clean build cache
docker builder prune -f
```

**Free up disk space:**
```powershell
# See disk usage
docker system df

# Complete cleanup (removes everything!)
docker system prune -a --volumes -f
```

### Troubleshooting

| Symptom | Cause | Solution |
|---------|-------|----------|
| `Error response from daemon: pull access denied` | Image not accessible | Check internet connection, try `docker login` if using private registry |
| `Can't connect to http://localhost:3000` | Port not published or server not bound correctly | Ensure `-p 3000:3000` in config and server binds to `0.0.0.0` |
| `Login failed for user 'sa'` | Incorrect SQL Server password | Check `MSSQL_SA_PASSWORD` in `.env.database`, ensure 8+ chars with complexity |
| `Database 'complete_development' does not exist` | Database not initialized | Run `docker compose [...] run --rm app bin/rails db:create db:migrate` |
| Slow performance on Windows | Using Hyper-V instead of WSL2 | Switch Docker Desktop to WSL2 backend in settings |
| File changes not detected | File watching issues on Windows | Set `FORCE_POLLING=1` environment variable |
| `Can't connect to Redis` | Redis service not ready | Check with `docker compose [...] ps redis` and `docker compose [...] logs redis` |
| `Debugger not attaching` | Debug port not exposed | Ensure `RUBY_DEBUG_OPEN=true` and check for rdbg banner in logs |
| `Volume mount failed` | Path or permissions issue | Ensure project is in accessible location, not in restricted Windows folder |
| `Bundle install fails` | Network or permission issue | Try clearing bundle volume: `docker volume rm dfe-complete_bundle` |

**General debugging steps:**
1. Check service status: `docker compose -f docker-compose.yml -f docker-compose.dev.yml ps`
2. View logs: `docker compose -f docker-compose.yml -f docker-compose.dev.yml logs [service]`
3. Verify configuration: `docker compose -f docker-compose.yml -f docker-compose.dev.yml config`
4. Test connectivity: `docker compose -f docker-compose.yml -f docker-compose.dev.yml exec app ping db`

**Get help:**
```powershell
# Show Docker Compose help
docker compose --help

# Show logs for specific service
docker compose -f docker-compose.yml -f docker-compose.dev.yml logs --tail=100 -f app

# Execute shell in running container
docker compose -f docker-compose.yml -f docker-compose.dev.yml exec app bash
```

### Alternative: Dev Containers (VS Code / Cursor)

Use the provided Dev Container to develop entirely inside Docker while editing in VS Code/Cursor. This reuses the existing Compose setup.

**What it uses:**
- `.devcontainer/devcontainer.json` references `docker-compose.yml` and `docker-compose.dev.yml`
- Targets the `app` service and also starts `js`, `sidekiq`, `db`, `redis`, and `redis-insight`
- Workspace inside container: `/srv/app`
- Remote user: `rails`
- Forwarded ports: `3000` (Rails), `5540` (Redis Insight), `6379` (Redis), `1433` (SQL Server)

**Quick start:**
1. Install the "Dev Containers" extension
2. Open the project folder
3. Press `Ctrl+Shift+P` → "Dev Containers: Reopen in Container"
4. Wait for build on first run (5–10 minutes)

After it starts, the Rails app is available at `http://localhost:3000` and Redis Insight at `http://localhost:5540`.

**Run commands inside the Dev Container:**
Open a terminal in VS Code (inside the container) and run, for example:
```powershell
# Rails console
bin/rails console

# Run migrations
bin/rails db:migrate

# Run tests
bin/rspec
```

**Attach to an already-running container (optional):**
If your Compose stack is already up and you wish to avoid rebuilding:
1. `Ctrl+Shift+P` → "Dev Containers: Attach to Running Container..."
2. Select `dfe-complete-app-1`
3. The workspace root inside will be `/srv/app`

**Notes and tips:**
- Dependency volumes (`bundle`, `node_modules`, `tmp`, `log`) are managed by Compose and persist between sessions
- To rebuild images after dependency changes, use the standard Compose commands from your host or the container terminal
- If file changes aren’t detected on Windows, set `FORCE_POLLING=1` and restart the `js` service

---

## Quick Reference

**Start development:**
```powershell
docker compose -f docker-compose.yml -f docker-compose.dev.yml up -d
```

**View logs:**
```powershell  
docker compose -f docker-compose.yml -f docker-compose.dev.yml logs -f app
```

**Run console:**
```powershell
docker compose -f docker-compose.yml -f docker-compose.dev.yml run --rm app bin/rails console
```

**Run tests:**
```powershell
docker compose -f docker-compose.yml -f docker-compose.dev.yml run --rm -e RAILS_ENV=test -e DATABASE_HOST=db app bin/rspec
```

**Stop everything:**
```powershell
docker compose -f docker-compose.yml -f docker-compose.dev.yml down
```
