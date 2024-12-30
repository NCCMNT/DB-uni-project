import random


def generate_link(section, length=16):
    link = f"https://skibidischool.pl/{section}/"
    for _ in range(length):
        link += random.choice("abcdefghijklmnopqrstuvwxyz1234567890")
    return link
