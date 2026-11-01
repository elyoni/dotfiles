# md2outlook: convert markdown to HTML for pasting into Outlook
function md2outlook() {
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        cat <<'USAGE'
Usage:
  md2outlook                        clipboard markdown -> clipboard HTML
  md2outlook <input.md>             file markdown      -> clipboard HTML
  md2outlook <input.md> <out.html>  file markdown      -> HTML file
  md2outlook -h | --help            show this help

Then paste (ctrl+v) into Outlook.
USAGE
        return 0
    fi

    local in="$1" out="$2"
    local -a pd=(pandoc -f markdown+hard_line_breaks -t html)
    if [[ -n "$in" && ! -f "$in" ]]; then
        echo "md2outlook: no such file: $in (try --help)" >&2
        return 1
    fi
    if [[ -n "$out" ]]; then
        "${pd[@]}" "$in" -o "$out"
    elif [[ -n "$in" ]]; then
        "${pd[@]}" "$in" | xclip -selection clipboard -t text/html
    else
        xclip -selection clipboard -o | "${pd[@]}" | xclip -selection clipboard -t text/html
    fi
}
