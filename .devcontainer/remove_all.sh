# Silme işlemi: .devcontainer ve .gitignore hariç her şeyi kaldır
find . \
  -mindepth 1 \
  ! -name '.devcontainer' \
  ! -path './.devcontainer/*' \
  ! -name 'README.md' \
  ! -name '.gitignore' \
  ! -name '.git' \
  ! -path './.git/*' \
  -exec rm -rf {} +