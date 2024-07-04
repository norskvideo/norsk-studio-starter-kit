command -v envsubst  >/dev/null 2>&1 || {
  envsubst() {
    sed 's/"/\\"/g' | eval "echo \"$(cat -)\""
  }
}
