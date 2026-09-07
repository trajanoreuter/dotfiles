# Copiado de /usr/share/omarchy/default/bash/fns/compression (Omarchy, MIT).
# No Omarchy o .zshrc carrega o original; este arquivo é só para macOS/outros.

# Compression
compress() { tar -czf "${1%/}.tar.gz" "${1%/}"; }
alias decompress="tar -xzf"
