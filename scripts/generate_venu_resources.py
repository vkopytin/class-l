"""Copy/scale FR965 artwork and prepare it for Venu's API 3.3 renderer.

Requires Pillow. Bitmap crops are separate resources so a large sprite atlas
does not have to coexist with Venu's legacy offscreen buffer. Clock hands are
converted to colored rectangles that can be rotated with software transforms.
"""

from pathlib import Path
import json
import math
import re
import shutil
import xml.etree.ElementTree as ET

from PIL import Image


ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / 'resources-round-454x454'
DESTINATION = ROOT / 'resources-venu'
SCALE = 390 / 454


def always_on_masks():
    """Binary black overlays with disjoint openings, below 10% even over white."""
    masks = []
    for phase in (0, 5):
        mask = Image.new('RGBA', (390, 390), (0, 0, 0, 255))
        pixels = mask.load()
        for y in range(390):
            for x in range(390):
                if (x + 3 * y) % 11 == phase:
                    pixels[x, y] = (0, 0, 0, 0)
        masks.append(mask)
    return masks


def pixel(value):
    return math.floor(value * SCALE + 0.5)


def hand_rectangles(image, pivot):
    colors = [(0, 0, 0), (0, 85, 85), (0, 170, 170), (255, 255, 255), (255, 85, 0)]
    rows = []
    rgba = image.convert('RGBA')
    for y in range(image.height):
        runs = []
        x = 0
        while x < image.width:
            value = rgba.getpixel((x, y))
            if value[3] < 128:
                x += 1
                continue
            color = min(colors, key=lambda c: sum((c[i] - value[i]) ** 2 for i in range(3)))
            start = x
            x += 1
            while x < image.width:
                next_value = rgba.getpixel((x, y))
                if next_value[3] < 128:
                    break
                next_color = min(colors, key=lambda c: sum((c[i] - next_value[i]) ** 2 for i in range(3)))
                if next_color != color:
                    break
                x += 1
            runs.append((color, start, x))
        rows.append(runs)
    active, rectangles = {}, []
    for y, runs in enumerate(rows + [[]]):
        current = set(runs)
        for key in list(active):
            if key not in current:
                color, x0, x1 = key
                y0 = active.pop(key)
                points = [[round(x - pivot[0], 4), round(yy - pivot[1], 4)]
                          for x, yy in ((x0, y0), (x1, y0), (x1, y), (x0, y))]
                rectangles.append([(color[0] << 16) | (color[1] << 8) | color[2], points])
        for key in current:
            active.setdefault(key, y)
    return rectangles


def main():
    DESTINATION.mkdir(exist_ok=True)
    assets = {}
    for path in SOURCE.glob('*.png'):
        with Image.open(path) as original:
            size = tuple(pixel(value) for value in original.size)
            # Indexed transparency remains binary on the original Venu.
            image = original.resize(size, Image.Resampling.NEAREST).convert('RGBA')
            image.save(DESTINATION / path.name)
            assets[path.name] = image
    (DESTINATION / 'fonts').mkdir(exist_ok=True)
    for path in (SOURCE / 'fonts').iterdir():
        shutil.copy2(path, DESTINATION / 'fonts' / path.name)

    entries = []
    mapping = {'background': [], 'moon': [], 'twilight': [], 'weather': []}
    def bitmap(name, image, filename=None):
        filename = filename or name + '.png'
        image.save(DESTINATION / filename)
        entries.append(f'    <bitmap id="{name}" filename="{filename}" />')
        return name

    edges = [0, 98, 195, 293, 390]
    for row in range(4):
        for column in range(4):
            x0, y0 = edges[column], edges[row]
            tile = assets['clock-example.png'].crop((x0, y0, edges[column + 1], edges[row + 1]))
            name = bitmap(f'background{row * 4 + column}', tile)
            mapping['background'].append([name, x0, y0])
    reconstructed = Image.new('RGBA', (390, 390))
    for name, x, y in mapping['background']:
        with Image.open(DESTINATION / (name + '.png')) as tile:
            reconstructed.paste(tile, (x, y))
    assert reconstructed.tobytes() == assets['clock-example.png'].tobytes()
    bitmap('batteryLevel', assets['battery-level.png'], 'battery-level.png')
    # Rescaling FR965's 50% checkerboard does not enforce Venu's 10% limit.
    aod, aod_alt = always_on_masks()
    bitmap('aod', aod, 'aod-1.png')
    bitmap('aodAlt', aod_alt, 'aod-1-alt.png')

    lib = (ROOT / 'src-fr965-454x454/lib.mc').read_text(encoding='utf-8')
    for group, constant, filename, size in [
        ('moon', 'moonTileCoords', 'moon-phases-30x30.png', 30),
        ('twilight', 'twilightCoords', 'sunset-sunrise-tiles-40x40.png', 48),
    ]:
        content = re.search(rf'const {constant} = (.*?);', lib, re.S)[1]
        coordinates = json.loads(content)
        for index, (x, y) in enumerate(coordinates):
            x, y, side = pixel(x), pixel(y), pixel(size)
            assert x + side <= assets[filename].width and y + side <= assets[filename].height
            image = assets[filename].crop((x, y, x + side, y + side))
            name = bitmap(f'{group}{index}', image)
            mapping[group].append(name)

    weather = (ROOT / 'src-fr965-454x454/srv.weather.mc').read_text(encoding='utf-8')
    coordinates = list(dict.fromkeys((int(x), int(y)) for x, y in re.findall(r'tileCoordinates = \[(\d+), (\d+)\]', weather)))
    coordinates.insert(0, (10, 24))
    for index, (x, y) in enumerate(coordinates):
        width, height = (40, 40) if index == 0 else (44, 41)
        x, y, width, height = pixel(x), pixel(y), pixel(width), pixel(height)
        assert x + width <= assets['weather-conditions.png'].width
        assert y + height <= assets['weather-conditions.png'].height
        image = assets['weather-conditions.png'].crop((x, y, x + width, y + height))
        name = bitmap(f'weather{index}', image)
        mapping['weather'].append([name, x, y])

    hand_data = {}
    for name, pivot in [('hour', (13, 66)), ('minute', (10, 88)), ('seconds', (8, 92))]:
        hand_data[name] = hand_rectangles(assets[name + 'Hand.png'], [value * SCALE for value in pivot])
        area = sum((points[1][0] - points[0][0]) * (points[2][1] - points[1][1])
                   for color, points in hand_data[name])
        alpha = assets[name + 'Hand.png'].getchannel('A')
        opaque_pixels = sum(alpha.histogram()[128:])
        assert abs(area - opaque_pixels) < 0.01
    data_lines = ['<resources>']
    for name, rectangles in hand_data.items():
        data_lines.append(f'    <jsonData id="{name}HandRectangles">{json.dumps(rectangles)}</jsonData>')
    data_lines.append('</resources>')
    (DESTINATION / 'hands.xml').write_text('\n'.join(data_lines) + '\n', encoding='utf-8', newline='\n')
    (DESTINATION / 'drawables.xml').write_text('<drawables>\n' + '\n'.join(entries) + '\n</drawables>\n', encoding='utf-8', newline='\n')
    (DESTINATION / 'mapping.json').write_text(json.dumps(mapping, indent=2) + '\n', encoding='utf-8', newline='\n')
    print('Copied/scaled FR965 artwork; created', len(entries), 'small bitmap resources.')
    print('Hand rectangle counts:', {name: len(value) for name, value in hand_data.items()})


if __name__ == '__main__':
    main()
