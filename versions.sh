#!/usr/bin/env bash
set -Eeuo pipefail

distsSuites=( "$@" )
if [ "${#distsSuites[@]}" -eq 0 ]; then
	distsSuites=( */*/ )
	json='{}'
else
	json="$(< versions.json)"
fi
distsSuites=( "${distsSuites[@]%/}" )

for version in "${distsSuites[@]}"; do
	codename="$(basename "$version")"
	dist="$(dirname "$version")"
	if [ "$dist" != 'alpine' ]; then
		doc='{"variants": [ "curl", "scm", "" ]}'
		suite=
		case "$dist" in
			debian)
				# "stable", "oldstable", etc.
				suite="$(
					wget -qO- -o /dev/null "https://deb.debian.org/debian/dists/$codename/Release" \
						| gawk -F ':[[:space:]]+' '$1 == "Suite" { print $2 }'
				)"
				;;
			ubuntu)
				suite="$(
					wget -qO- -o /dev/null "http://archive.ubuntu.com/ubuntu/dists/$codename/Release" \
						| gawk -F ':[[:space:]]+' '$1 == "Version" { print $2 }'
				)"
				;;
		esac
		if [ -n "$suite" ]; then
			export suite
			doc="$(jq <<<"$doc" -c '.suite = env.suite')"
			echo "$version: $suite"
		else
			echo "$version: ???"
		fi
	else
		doc='{"variants": [ "" ]}'
		updates="$(
			docker pull --quiet "$dist:$codename" > /dev/null
			docker run --rm "$dist:$codename" apk list --no-cache --quiet --upgradeable \
				| sed -re 's/ .*$//; s/-([0-9])/=\1/'
		)"
		updates="$(jq <<<"$updates" -csR 'rtrimstr("\n") | split("\n")')"
		echo "$version: pkgs to update: $(jq <<<"$updates" -r 'length')"
		export updates
		doc="$(jq <<<"$doc" -c '.updates = (env.updates | fromjson)')"
	fi
	export doc version
	json="$(jq <<<"$json" -c --argjson doc "$doc" '.[env.version] = $doc')"
done

jq <<<"$json" -S . > versions.json
