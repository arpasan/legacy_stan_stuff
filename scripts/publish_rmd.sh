#!/usr/bin/env bash
# Publish an Rmd to GitHub Pages with a fingerprinted HTML name so Safari/CDN
# cannot keep serving a stale document under the same URL.
#
# Usage:
#   scripts/publish_rmd.sh <path/to/file.Rmd> <slug>
# Example:
#   scripts/publish_rmd.sh profit_optimization/profit_optimization.Rmd profit
#
# Writes:
#   docs/<slug>_r<stamp>.html   # actual report (unique URL every publish)
#   docs/<slug>.html            # no-cache redirect → fingerprinted file
# Also refreshes docs/<legacy_name>.html redirect when SLUG_LEGACY is set.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
RMD="${1:?Rmd path required}"
SLUG="${2:?slug required (e.g. profit)}"
STAMP="${PUBLISH_STAMP:-$(date -u +%Y%m%d%H%M%S)}"
FINGERPRINT="${SLUG}_r${STAMP}.html"
HEADER="${ROOT}/docs/header_nocache.html"

if [[ ! -f "${ROOT}/${RMD}" ]]; then
  echo "missing ${ROOT}/${RMD}" >&2
  exit 1
fi

cd "${ROOT}"
# Pandoc resolves includes relative to the Rmd; use an absolute header path.
Rscript -e "
rmarkdown::render(
  '${RMD}',
  output_file = '${FINGERPRINT}',
  output_dir = '${ROOT}/docs',
  output_options = list(includes = list(in_header = '${HEADER}'))
)
"

write_redirect() {
  local dest="$1"
  local target="$2"
  cat > "${ROOT}/docs/${dest}" <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
  <meta http-equiv="Pragma" content="no-cache" />
  <meta http-equiv="Expires" content="0" />
  <meta http-equiv="refresh" content="0; url=${target}" />
  <link rel="canonical" href="${target}" />
  <title>Redirecting…</title>
</head>
<body>
  <p><a href="${target}">Continue to the latest report</a>.</p>
</body>
</html>
EOF
}

write_redirect "${SLUG}.html" "${FINGERPRINT}"
# Common legacy aliases for this repo
case "${SLUG}" in
  profit) write_redirect "profit_optimization.html" "${FINGERPRINT}" ;;
  credit_fraud|fraud)
    write_redirect "credit_fraud.html" "${FINGERPRINT}"
    write_redirect "capital1_arpasan.html" "${FINGERPRINT}"
    ;;
  wages) write_redirect "wages.html" "${FINGERPRINT}" ;;
esac

echo "PUBLISHED docs/${FINGERPRINT}"
echo "STABLE   https://arpasan.github.io/legacy_stan_stuff/${SLUG}.html"
echo "DIRECT   https://arpasan.github.io/legacy_stan_stuff/${FINGERPRINT}"
