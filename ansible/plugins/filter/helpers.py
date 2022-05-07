from typing import List, Dict, Any, Mapping, Union


def _format(items: Union[List, Dict], pattern: str) -> str:
    if isinstance(items, dict):
        return pattern.format(**items)

    return pattern.format(*items)


def multi_extract(key: str, container: Mapping[str, Any], subkeys: List[str]) -> List[Any]:
    return [container[key][subkey] for subkey in subkeys]


class FilterModule:
    def filters(self):
        return {"format": _format, "multi_extract": multi_extract}
