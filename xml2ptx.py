# apply the xslt stylesheet to all available xml files

import lxml.etree as ET
import re
from pathlib import Path
from rich import print
import typer
from typing import Optional
from typing_extensions import Annotated


XSLT_PATH = Path(__file__).parent / "docutils2ptx.xsl"


def to_snake(name):
    name = re.sub(r"(?<!^)(?=[A-Z])", "-", name).lower()
    return name


# handles acronyms better
def camel_to_snake(name):
    name = re.sub("(.)([A-Z][a-z]+)", r"\1-\2", name)
    return re.sub("([a-z0-9])([A-Z])", r"\1-\2", name).lower()


def transform_one_page(xml_file: Path, out_path: Path):
    try:
        dom = ET.parse(xml_file)
    except Exception as e:
        print(f"Failed to parse {xml_file}")
        print(e)
        return
    params = {
        "filename": ET.XSLT.strparam(str(xml_file.stem)),
        "folder": ET.XSLT.strparam(str(xml_file.parent)),
    }

    xslt = ET.parse(XSLT_PATH)
    transform = ET.XSLT(xslt)
    try:
        newdom = transform(dom, **params)
        ptx_file = out_path.with_suffix(".ptx")
        ptx_file.parent.mkdir(parents=True, exist_ok=True)
        with open(ptx_file, "w") as ptfile:
            ptfile.write(ET.tostring(newdom, pretty_print=True).decode("utf8"))
    except Exception as e:
        print(f"Failed to transform {xml_file}")
        print(e)
        return


app = typer.Typer()


@app.command()
def transform(
    xml: Annotated[str, typer.Option(help="Path to the xml directory.")],
    out: Annotated[
        str, typer.Option(help="Path to the output directory.")
    ] = "pretext/",
):
    xml_path = Path(xml)
    out_path = Path(out)
    for file in sorted(xml_path.glob("**/*.xml")):
        print(file.relative_to(xml_path))
        ptx_path = file.relative_to(xml_path)
        transform_one_page(file, out_path / ptx_path )
    ...


if __name__ == "__main__":
    app()
