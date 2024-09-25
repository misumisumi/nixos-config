"""layout and group"""

import re

from libqtile import qtile
from libqtile.backend import base
from libqtile.config import DropDown, Group, Match, ScratchPad
from libqtile.log_utils import logger

from my_modules.layouts import layout1, layout2, layout3, layout4
from my_modules.utils import get_n_screen
from my_modules.variables import GlobalConf

_rule_code = [
    {"wm_class": "code"},
    {"wm_class": GlobalConf.terminal_class if GlobalConf.terminal_class is not None else GlobalConf.terminal},
]

_rule_browse = [{"wm_class": "vivaldi-stable"}, {"wm_class": "firefox"}]

_rule_analyze = [
    {"title": "WaveSurfer 1.8.8p5"},
    {"wm_class": "thunar"},
    {"wm_class": "nemo"},
]

_rule_full = [
    {"wm_class": "Steam"},
    {"wm_class": "lutris"},
    {"wm_class": "resolve"},
    {"wm_class": "krita"},
    {"wm_class": "Gimp"},
    {"wm_class": "Blender"},
    {"wm_class": "unityhub"},
    {"wm_class": "Unity"},
    {"wm_class": "obs"},
    {"wm_class": ".obs-wrapped_"},
    {"wm_class": "audacity"},
    {"wm_class": "Looking Glass (client)"},
]

_rule_sns = [
    {"wm_class": "slack"},
    {"wm_class": "discord"},
    {"wm_class": "element"},
    {"wm_class": "ferdium"},
    {"wm_class": "zoom"},
]

_rule_media = [
    {"wm_class": "spotify"},
    {"wm_class": "pavucontrol"},
    {"wm_class": ".blueman-manager-wrapped"},
]

group_and_rule = {
    "code": ("", (layout2, layout3), _rule_code),
    "browse": ("", (layout1,), _rule_browse),
    "analyze": ("󰉕", (layout1,), _rule_analyze),
    "full": ("󰓓", (layout4,), _rule_full),
    "sns": ("󰡠", (layout1,), _rule_sns),
    "media": ("󰓇", (layout2, layout3), _rule_media),
}


_rule_scratchpad = {
    DropDown("term", GlobalConf.terminal, opacity=0.8),
    DropDown("copyq", "copyq show", opacity=0.7),
    DropDown("bluetooth", "blueman-manager", opacity=0.7),
    DropDown("volume", "pavucontrol", opacity=0.7),
}


class MatchWithCurrentScreen(Match):
    def __init__(self, screen_id: str | None = None, **kwargs):
        super().__init__(**kwargs)
        self.screen_id = screen_id

    def compare(self, client: base.Window) -> bool:
        for property_name, rule_value in self._rules.items():
            if property_name == "title":
                value = client.name
            elif "class" in property_name:
                wm_class = client.get_wm_class()
                if not wm_class:
                    return False
                if property_name == "wm_instance_class":
                    value = wm_class[0]
                else:
                    value = wm_class
            elif property_name == "role":
                value = client.get_wm_role()
            elif property_name == "func":
                return rule_value(client)
            elif property_name == "net_wm_pid":
                value = client.get_pid()
            elif property_name == "wid":
                value = client.wid
            else:
                value = client.get_wm_type()

            # Some of the window.get_...() functions can return None
            if value is None:
                return False

            is_focus = self.screen_id in re.sub("-[a-z0-9]+", "", qtile.current_group.name, flags=re.IGNORECASE)
            match = self._get_property_predicate(property_name, value)
            if not match(rule_value) or not is_focus:
                return False

        if not self._rules:
            return False
        return True


_pentablet = {"creation": ("󰂫", layout4)}

GROUP_PER_SCREEN = len(group_and_rule)


def _set_groups():
    groups = []
    n_screen = get_n_screen()
    for n in range(n_screen):
        for k, (label, layouts, rules) in group_and_rule.items():
            if n == 1 and len(layouts) > 1:
                layouts = layouts[1]
            else:
                layouts = layouts[0]
            name = "{}-{}".format(n, k)
            matches = [MatchWithCurrentScreen(screen_id=str(n), **rule) for rule in rules]
            groups.append(Group(name, layouts=layouts, matches=matches, label=label))
    if GlobalConf.has_pentablet:
        name = list(_pentablet.keys())[0]
        groups.append(
            Group(
                "{}".format(name),
                layouts=_pentablet[name][1],
                label=_pentablet[name][0],
            )
        )
    groups.append(ScratchPad("scratchpad", _rule_scratchpad))

    return groups


groups = _set_groups()
