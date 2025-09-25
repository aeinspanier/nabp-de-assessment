import argparse
import zipfile
import datetime as dt
from pathlib import Path
from typing import Optional


def zip_directory_with_exclusions(project_root_dir: Path, descriptor: Optional[str] = None) -> None:
    exclude_dirs = [
        Path(project_root_dir).joinpath("data"),
        Path(project_root_dir).joinpath("deliverable"),
        Path(project_root_dir).joinpath("dbt_packages"),
        Path(project_root_dir).joinpath("venv")
    ]
    time_now = f"{dt.datetime.now():%Y%m%d_%H%M%S}"
    if descriptor is None:
        output_file_name = f"nabp_de_assessment_deliverable_{time_now}.zip"
    else:
        descriptor_cln = "_".join(descriptor.split())
        output_file_name = f"{descriptor_cln}_nabp_de_assessment_deliverable_{time_now}.zip"
    output_zip_path = Path(project_root_dir).joinpath("deliverable", output_file_name)
    with zipfile.ZipFile(output_zip_path, "w", zipfile.ZIP_DEFLATED) as zipf:
        for file_path in project_root_dir.rglob('*'):
            if any(parent in exclude_dirs for parent in file_path.parents):
                continue
            if file_path.is_file():
                arcname = file_path.relative_to(project_root_dir)
                zipf.write(file_path, arcname)
    print(f"Deliverable output to {output_zip_path}")

if __name__ == "__main__":
    try:
        parser = argparse.ArgumentParser()
        parser.add_argument(
            "name", nargs="?", type=str, default=None, help="Optional name to label the deliverable"
        )
        args = parser.parse_args()
        project_dir = Path(__file__).parent.resolve()
        zip_directory_with_exclusions(project_root_dir=project_dir, descriptor=args.name)
    except Exception as e:
        print(
            "Failed to produce the deliverable. Please resolve the error below and try again, or "
            "please zip up everything except the subdirectories:\n  * data/\n  * venv/ (if you "
            "made a virtualenv dir per the README)\n  * dbt_packages/\n  * deliverable\.\n\n"
            f"Encountered error {e}"
        )
