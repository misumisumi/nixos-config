import subprocess
from pathlib import Path


def get_n_monitors(has_pentablet: bool) -> str:
    cmd = [r"xrandr --listmonitors | head -n1 | awk -F' ' '{print $2}'"]
    monitors = subprocess.run(cmd, shell=True, capture_output=True, text=True).stdout.replace("\n", "")
    monitors = int(monitors)
    if has_pentablet:
        monitors -= 1

    return monitors


def get_phy_monitors(has_pentablet: bool, activate_only: bool = False) -> list[tuple[str, tuple[str]]]:
    xrandr = "xrandr --listmonitors" if activate_only else "xrandr --listmonitors"
    cmd = (
        xrandr
        + r" | tail -n+2 | awk -F' ' '{print $2,$3}' | sed 's/\(.*\)\/.*x\(.*\)\/.*$/\1x\2/' | sed -E 's/\+\*?//g'"
    )
    monitors = subprocess.run(cmd, shell=True, capture_output=True, text=True).stdout.split("\n")[:-1]
    monitors = [(output, tuple(resolution.split("x"))) for output, resolution in map(lambda x: x.split(" "), monitors)]
    if has_pentablet:
        monitors = monitors[:-1]

    return monitors


def get_monitor_status() -> dict:
    status = {}

    xrandr = "xrandr"
    connected = xrandr + r" | grep connected | awk -F' ' '{print $1}'"
    status["connected"] = subprocess.run(connected, shell=True, capture_output=True, text=True).stdout.split("\n")[:-1]
    disconnected = xrandr + r" | grep disconnected | awk -F' ' '{print $1}'"
    status["disconnected"] = subprocess.run(disconnected, shell=True, capture_output=True, text=True).stdout.split(
        "\n"
    )[:-1]

    return status


def get_wallpapers(path: Path, laptop: bool) -> list[str]:
    if laptop:
        wallpapers = list(path.joinpath("fixed").glob("*.png"))
    else:
        wallpapers = list(path.joinpath("unfixed").glob("*.png"))
    wallpapers.sort()

    return wallpapers
