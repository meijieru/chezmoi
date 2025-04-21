settings({
  inotifyMode = "Modify",
  maxProcesses = 1,
  nodaemon = true,
})

sync({
  default.rsyncssh,
  source = os.getenv("SOURCE"),
  host = os.getenv("HOST"),
  targetdir = os.getenv("TARGETDIR"),
  delay = 0,
  exclude = { "__pycache__", "exp", "checkpoints", "*.log", "*.tar", "pretrained", ".git", ".venv" },
  -- init           = false,
  delete = "true",
  rsync = {
    binary = "/usr/bin/rsync",
    archive = true,
    compress = true,
    verbose = true,
    bwlimit = 2000,
  },
})
