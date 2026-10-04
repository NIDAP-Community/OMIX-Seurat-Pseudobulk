#!/usr/bin/env python3

import json
import re
from pathlib import Path


panel_path = Path(".codeocean/app-panel.json")
panel_text = panel_path.read_text()
panel = json.loads(panel_text)

assert panel["named_parameters"] is True
assert "help_text" not in panel_text
# Code Ocean removes an empty top-level datasets array when it normalizes the
# App Panel. Attached data assets are recorded separately in datasets.json, so
# an omitted key and an explicit empty array are equivalent here.
assert panel.get("datasets", []) == []

parameters = panel["parameters"]
names = [parameter.get("param_name") for parameter in parameters]
expected = [
    "seurat_rds",
    "donor_column",
    "group_column",
    "cell_type_column",
    "cell_type",
    "metadata_columns",
    "cell_filter_column",
    "cell_filter_values",
    "aggregation_method",
    "assay",
    "layer",
    "feature_id_column",
    "min_cells",
    "on_insufficient_cells",
]
assert names == expected, (names, expected)
assert len(names) == len(set(names))

main_text = Path("code/main.R").read_text()
cli_names = set(re.findall(r'make_option\("--([a-z0-9_]+)"', main_text))
assert cli_names == set(expected) | {"output_dir"}, sorted(cli_names)
assert "--feature_id_column is fixed to GeneName" in main_text

by_name = {parameter["param_name"]: parameter for parameter in parameters}
expected_defaults = {
    "metadata_columns": "",
    "cell_filter_column": "",
    "cell_filter_values": "",
    "aggregation_method": "sum_counts",
    "assay": "auto",
    "layer": "auto",
    "feature_id_column": "GeneName",
    "min_cells": "20",
    "on_insufficient_cells": "error",
}
for name, default in expected_defaults.items():
    # Code Ocean omits empty-string defaults when it normalizes text fields.
    # An omitted optional text default and an explicit empty default both map
    # to the same blank CLI value.
    actual = by_name[name].get("default_value", "" if default == "" else None)
    assert actual == default, (
        name,
        actual,
    )

for name in ["donor_column", "group_column", "cell_type_column", "cell_type"]:
    assert by_name[name]["required"] is True
    assert "default_value" not in by_name[name]

assert by_name["seurat_rds"]["type"] == "file"
assert by_name["aggregation_method"]["extra_data"] == [
    "sum_counts",
    "mean_harmony_corrected_expression",
    "mean_sctransform_expression",
]
assert by_name["feature_id_column"]["type"] == "list"
assert by_name["feature_id_column"]["extra_data"] == ["GeneName"]
assert by_name["on_insufficient_cells"]["extra_data"] == ["error", "drop"]
assert "output_dir" not in names

environment = json.loads(Path(".codeocean/environment.json").read_text())
assert environment["base_image"] == "codeocean/omix-r-seurat-conversion:r4.4.3-v1"
assert ":latest" not in environment["base_image"]

print("OMIX Seurat Pseudobulk App Panel and runtime bindings passed")
