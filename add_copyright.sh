#!/bin/bash
# add_copyright.sh — Adds AGPL-3.0 copyright header to every source file
# Run from repo root: chmod +x add_copyright.sh && ./add_copyright.sh

OWNER="Daland Montgomery"
YEAR="2026"

# -- style comments (Haskell, Lean, Agda, SQL)
DASH_HEADER="-- Copyright (c) $YEAR $OWNER
-- SPDX-License-Identifier: AGPL-3.0-or-later
"

# // style comments (Rust, JS)
SLASH_HEADER="// Copyright (c) $YEAR $OWNER
// SPDX-License-Identifier: AGPL-3.0-or-later
"

# # style comments (Python, TOML, YAML, Shell, Makefile)
HASH_HEADER="# Copyright (c) $YEAR $OWNER
# SPDX-License-Identifier: AGPL-3.0-or-later
"

# <!-- style comments (HTML)
HTML_HEADER="<!-- Copyright (c) $YEAR $OWNER — SPDX-License-Identifier: AGPL-3.0-or-later -->
"

add_header() {
    local file="$1"
    local header="$2"
    
    # Skip if already has copyright
    if grep -q "Copyright (c)" "$file" 2>/dev/null; then
        echo "  SKIP (already has copyright): $file"
        return
    fi
    
    # Skip binary files
    if file "$file" | grep -q "binary"; then
        echo "  SKIP (binary): $file"
        return
    fi

    # For Python files: preserve shebang line
    if [[ "$file" == *.py ]] && head -1 "$file" | grep -q "^#!"; then
        local shebang=$(head -1 "$file")
        local rest=$(tail -n +2 "$file")
        printf '%s\n%s\n%s' "$shebang" "$header" "$rest" > "$file"
    # For Haskell files: preserve {- | module header by inserting before it
    elif [[ "$file" == *.hs ]] && head -1 "$file" | grep -q "^{-"; then
        local tmp=$(mktemp)
        printf '%s\n' "$header" > "$tmp"
        cat "$file" >> "$tmp"
        mv "$tmp" "$file"
    else
        local tmp=$(mktemp)
        printf '%s\n' "$header" > "$tmp"
        cat "$file" >> "$tmp"
        mv "$tmp" "$file"
    fi
    
    echo "  ADDED: $file"
}

COUNT=0

echo "Adding AGPL-3.0 copyright headers..."
echo "Owner: $OWNER"
echo "Year:  $YEAR"
echo "========================================"

# Haskell (.hs)
for f in $(find . -name "*.hs" -not -path "*/target/*" -not -path "*/.lake/*"); do
    add_header "$f" "$DASH_HEADER"
    ((COUNT++))
done

# Lean (.lean)
for f in $(find . -name "*.lean" -not -path "*/target/*" -not -path "*/.lake/*"); do
    add_header "$f" "$DASH_HEADER"
    ((COUNT++))
done

# Agda (.agda)
for f in $(find . -name "*.agda" -not -path "*/target/*" -not -path "*/.lake/*"); do
    add_header "$f" "$DASH_HEADER"
    ((COUNT++))
done

# Rust (.rs)
for f in $(find . -name "*.rs" -not -path "*/target/*"); do
    add_header "$f" "$SLASH_HEADER"
    ((COUNT++))
done

# Python (.py)
for f in $(find . -name "*.py" -not -path "*/target/*" -not -path "*/__pycache__/*"); do
    add_header "$f" "$HASH_HEADER"
    ((COUNT++))
done

# TOML (.toml)
for f in $(find . -name "*.toml" -not -path "*/target/*"); do
    add_header "$f" "$HASH_HEADER"
    ((COUNT++))
done

# Markdown (.md)
for f in $(find . -name "*.md" -not -path "*/target/*" -not -path "*/.lake/*" -not -name "LICENSE*"); do
    add_header "$f" "$HTML_HEADER"
    ((COUNT++))
done

# HTML (.html)
for f in $(find . -name "*.html" -not -path "*/target/*"); do
    add_header "$f" "$HTML_HEADER"
    ((COUNT++))
done

# Shell scripts (.sh)
for f in $(find . -name "*.sh" -not -path "*/target/*"); do
    add_header "$f" "$HASH_HEADER"
    ((COUNT++))
done

echo "========================================"
echo "Done. Processed $COUNT files."
echo ""
echo "Next steps:"
echo "  1. Download AGPL-3.0 license:"
echo "     curl -o LICENSE https://www.gnu.org/licenses/agpl-3.0.txt"
echo "  2. git add -A && git commit -m 'Add AGPL-3.0 copyright headers'"
