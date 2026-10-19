"""Check the shipped Venu masks against OLED pixel and persistence limits."""

from pathlib import Path
import unittest

from PIL import Image


ROOT = Path(__file__).resolve().parents[1]


class VenuAlwaysOnMasksTest(unittest.TestCase):
    def setUp(self):
        self.masks = []
        for filename in ('aod-1.png', 'aod-1-alt.png'):
            with Image.open(ROOT / 'resources-venu' / filename) as image:
                self.assertEqual(image.size, (390, 390))
                self.masks.append(image.convert('RGBA'))

    def test_worst_case_white_frame_stays_below_ten_percent(self):
        # Count actual circular display pixels, not the larger square bitmap.
        display = [(x, y) for y in range(390) for x in range(390)
                   if (2 * x - 389) ** 2 + (2 * y - 389) ** 2 < 390 ** 2]
        for mask in self.masks:
            with self.subTest(mask=self.masks.index(mask)):
                pixels = mask.load()
                lit = sum(pixels[x, y][3] < 255 for x, y in display)
                # Reserve margin below Garmin's 10% threshold.
                self.assertLess(lit / len(display), 0.095)

    def test_masks_are_black_binary_and_alternate_every_pixel(self):
        first, second = [mask.load() for mask in self.masks]
        for y in range(390):
            for x in range(390):
                for pixel in (first[x, y], second[x, y]):
                    self.assertEqual(pixel[:3], (0, 0, 0))
                    self.assertIn(pixel[3], (0, 255))
                self.assertTrue(first[x, y][3] == 255 or second[x, y][3] == 255,
                                'A pixel must be black in at least every other minute')


if __name__ == '__main__':
    unittest.main()
