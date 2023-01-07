extends Node

func compress(number):
    var suffix = ""
    if number >= 1000000000.0:
        suffix = "B"
        number /= 1000000000.0
    elif number >= 1000000.0:
        suffix = "M"
        number /= 1000000.0
    elif number >= 1000.0:
        suffix = "K"
        number /= 1000.0
    return (str(round(number)) if round(number) >= 10 or suffix == "" else "%.1f" % number) + suffix
