old="$(mktemp)"
new="$(mktemp)"
if [ -n "$fs" ]; then
    fs="$(basename -a $fs)"
else
    fs="$(ls)"
fi
printf '%s\n' "$fs" >"$old"
printf '%s\n' "$fs" >"$new"
$EDITOR "$new"
[ "$(wc -l < "$new")" -ne "$(wc -l < "$old")" ] && exit
paste "$old" "$new" | while IFS= read -r names; do
    src="$(printf '%s' "$names" | cut -f1)"
    dst="$(printf '%s' "$names" | cut -f2)"
    if [ "$src" = "$dst" ] || [ -e "$dst" ]; then
        continue
    fi
    mv -- "$src" "$dst"
done
rm -- "$old" "$new"
lf -remote "send $id unselect"
