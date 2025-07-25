source /home/treefrog/.cache/wal/colors.sh

hex_to_rgb() {
    [[ -z "$1" ]] && { echo "No hex color provided." >&2; return 1; }
    hex="${1#"#"}"
    if [[ ${#hex} -ne 6 ]]; then
        # echo "Invalid hex format." >&2
        return 1
    fi
    r=$((16#${hex:0:2}))
    g=$((16#${hex:2:2}))
    b=$((16#${hex:4:2}))
    echo "$r $g $b"
}

if [[ -z "$color3" ]]; then
    echo "color3 is not set. Check your colors.sh file." >&2
    exit 1
fi

read r g b <<< "$(hex_to_rgb "$color3")"

while true; do
    for alpha in 0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1 0.9 0.8 0.7 0.7 0.7 0.6 0.5 0.4 0.3 0.2 0.1; do
        hyprctl keyword general:col.active_border "rgba($r,$g,$b,$alpha)"
        sleep 0.150
    done
done