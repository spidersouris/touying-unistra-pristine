import requests
from bs4 import BeautifulSoup

url = "https://di.pages.unistra.fr/pictogrammes/"
escape_chars = [
    "#",
    "$",
    "*",
    "[",
    "\\",
    "]",
    "_",
    "`",
]


def extract_typst_icon_map(soup, icon_pack):
    assert icon_pack in [
        "unistra",
        "nova",
    ], "Invalid icon pack specified, must be 'unistra' or 'nova'."

    classes = {
        "unistra": {
            "icon_class": ".un-icon",
            "class_class": ".un-class",
        },
        "nova": {
            "icon_class": ".nv-icon",
            "class_class": ".nv-class",
        },
    }

    prefix = "us" if icon_pack == "unistra" else "nv"
    prefix_hyphen = f"{prefix}-"
    font_name = "Unistra Symbol" if icon_pack == "unistra" else "novaicons"
    # url: https://s3.unistra.fr/master/common/assets/fonts/nova-icons/1.0.1/fonts/novaicons.ttf?AWSAccessKeyId=M2M78RKXPAP75Y692QZX&Signature=QzVHDIlE0dxe7NsiXplv969Bkuc%3D&Expires=1870941573&v=1.0.0

    print(f"Extracting {icon_pack} icons...")

    icon_divs = soup.select(".icon")

    icon_map = {}
    for icon_div in icon_divs:
        icon = icon_div.select_one(classes[icon_pack]["icon_class"])
        class_name = icon_div.select_one(classes[icon_pack]["class_class"])
        if icon and class_name:
            key = (
                class_name.get_text(strip=True)
                .replace(prefix_hyphen, "", 1)
                .split(" ")[0]
            )
            value = icon.get_text(strip=True)
            icon_map[key] = value

    typst_lines = [f"#let _{prefix}_icons = ("]
    for key, value in icon_map.items():
        if any(char in value for char in escape_chars):
            value = f"\\{value}"
        typst_lines.append(f'  "{key}": [{value}],')
    typst_lines.append(")")

    func_def = f'#let {prefix}-icon(name) = text(_{prefix}_icons.at(name), font: "{font_name}")'

    return "\n".join(typst_lines), func_def


response = requests.get(url)
soup = BeautifulSoup(response.text, "html.parser")
unistra_code, unistra_func = extract_typst_icon_map(soup, "unistra")
nova_code, nova_func = extract_typst_icon_map(soup, "nova")

with open("../src/icons.typ", "w", encoding="utf8") as f:
    f.write(unistra_code + "\n\n" + nova_code)
    f.write("\n\n")
    f.write(unistra_func + "\n\n" + nova_func)

print("Icons extracted and saved to src/icons.typ")
