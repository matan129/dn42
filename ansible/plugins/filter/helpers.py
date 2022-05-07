
def format(items, pattern):
    return pattern.format(*items)


class FilterModule:
    def filters(self):
        return {
            'format': format
        }
