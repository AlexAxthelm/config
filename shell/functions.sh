vgm() {
  local files=($(git ls-files --modified --others --exclude-standard))
  if [ ${#files[@]} -eq 0 ]; then
    echo "No modified or untracked files."
  else
    vim -p "${files[@]}"
  fi
}
