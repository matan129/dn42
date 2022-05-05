set -eo pipefail

for f in "$1"/data/route/*; do
  unset route maxlen action

  while read -r a b; do
    [[ "$a" == route: ]] && route="$b"
    [[ "$a" == max-length: ]] && maxlen="$b"
  done <"$f"

  while read -r nr faction fprefix _ fmaxlen _; do
    if [[ "${nr:0:1}" != '#' && "${nr:0:1}" != "" ]]; then
      if [[ "$(/usr/bin/ipcalc-ng --no-decorate -n "${route%/*}/${fprefix#*/}")" == "${fprefix%/*}" ]]; then
        action="$faction"
        [[ -z "$maxlen" ]] && maxlen="$fmaxlen"
        break
      fi
    fi
  done < "$1"/data/filter.txt

  prefixlen="${route#*/}"
  maxlen="$((maxlen > prefixlen ? maxlen : prefixlen))"
  maxlen="$((maxlen < 32 ? maxlen : 32))"

  # An IP block might be announced by multiple AS
  [[ $action == permit ]] && while read -r a b; do
    [[ "$a" == origin: ]] && echo "route $route max $maxlen as ${b:2};"
  done <"$f"
done > "$2"

true
