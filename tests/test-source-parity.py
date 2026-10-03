#!/usr/bin/env python3

import hashlib
import re
from pathlib import Path


expected_commit = "e3cc933ad812ca4af8fc6427e1f23e2a2ccd5e96"
expected_hash = "c1bc96c3135ca4d48aa1bb231e8a223b12d0040ccc92d5c0c17aae9bdd5c30cf"
source_record = Path("OMIX_MODULE_SOURCE.md").read_text()

commit_match = re.search(
    r"Canonical source reference:\*\*\s*\[`([0-9a-f]{40})`\]", source_record
)
assert commit_match, "Canonical source reference is missing"
assert commit_match.group(1) == expected_commit

managed_files = sorted(
    path.relative_to("code/functions").as_posix()
    for path in Path("code/functions").rglob("*")
    if path.is_file()
)
assert managed_files == ["Seurat_Pseudobulk.R"], managed_files

managed_path = Path("code/functions/Seurat_Pseudobulk.R")
observed_hash = hashlib.sha256(managed_path.read_bytes()).hexdigest()
assert observed_hash == expected_hash, observed_hash
assert source_record.count(f"`{expected_hash}`") >= 1
assert "`R/Seurat_Pseudobulk.R`" in source_record
assert "`code/functions/Seurat_Pseudobulk.R`" in source_record
assert ".syncweaver-lock.json` **Pending** generation by Syncweaver" in source_record

print("OMIX Seurat Pseudobulk managed-source provenance passed")
