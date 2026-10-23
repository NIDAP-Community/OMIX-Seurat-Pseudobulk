#!/usr/bin/env python3

import json
import re
from pathlib import Path


panel_path = Path(".codeocean/app-panel.json")
panel_text = panel_path.read_text()
panel = json.loads(panel_text)

assert panel["named_parameters"] is True
assert "help_text" not in panel_text
metadata_text = Path("metadata/metadata.yml").read_text()
assert "selected-set, or all retained cell types" in metadata_text
# A workflow-ready capsule declares the same representative asset both as an
# attached `/data` mount and as a visible, replaceable workflow input node.
datasets = json.loads(Path(".codeocean/datasets.json").read_text())
assert panel["datasets"] == [
    {"id": "fc787e18-e381-42b8-ad91-be986796d813", "name": "Seurat Object"}
]
assert [item["id"] for item in panel["datasets"]] == [
    item["id"] for item in datasets["attached_datasets"]
]

parameters = panel["parameters"]
names = [parameter.get("param_name") for parameter in parameters]
expected = [
    "seurat_rds",
    "donor_column",
    "group_column",
    "cell_type_column",
    "cell_type_mode",
    "cell_type",
    "cell_type_selection",
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

for name in ["donor_column", "group_column", "cell_type_column"]:
    assert by_name[name]["required"] is True
    assert "default_value" not in by_name[name]

assert by_name["seurat_rds"]["type"] == "file"
assert by_name["cell_type_mode"]["default_value"] == "one"
assert by_name["cell_type_mode"]["extra_data"] == ["one", "selected", "all"]
assert by_name["cell_type"]["type"] == "text"
assert "required" not in by_name["cell_type"]
assert by_name["cell_type_selection"]["type"] == "file"
assert "required" not in by_name["cell_type_selection"]
assert by_name["aggregation_method"]["extra_data"] == [
    "sum_counts",
    "mean_harmony_corrected_expression",
    "mean_sctransform_expression",
]
assert by_name["feature_id_column"]["type"] == "list"
assert by_name["feature_id_column"]["extra_data"] == ["GeneName"]
assert by_name["on_insufficient_cells"]["extra_data"] == ["error", "drop"]
assert "output_dir" not in names
result_names = [result["file_name"] for result in panel["results"]]
for collection_output in [
    "Cell_Type_Profile_Catalog.csv",
    "Pseudobulk_Collection_Manifest.dcf",
    "Pseudobulk_Collection_Run_Summary.txt",
]:
    assert collection_output in result_names
for message in [
    "--cell_type is required when --cell_type_mode one.",
    "--cell_type_selection is required when --cell_type_mode selected.",
    "--cell_type is only valid when --cell_type_mode one.",
    "--cell_type_selection is only valid when --cell_type_mode selected.",
]:
    assert message in main_text

environment = json.loads(Path(".codeocean/environment.json").read_text())
assert environment["base_image"] == "codeocean/omix-r-seurat-conversion:r4.4.3-v2"
assert ":latest" not in environment["base_image"]

print("OMIX Seurat Pseudobulk App Panel and runtime bindings passed")
