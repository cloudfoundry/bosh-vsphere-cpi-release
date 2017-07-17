import unittest

from pyvmomi_to_ruby.formatter import zero_to_empty_hash

class TestZeroToEmptyHash(unittest.TestCase):

    def test_none(self):
        self.assertEqual(zero_to_empty_hash(None), None)

    def test_0(self):
        self.assertEqual(zero_to_empty_hash(0), {})

    def test_seq(self):
        self.assertEqual(zero_to_empty_hash(
            ['a', 0, 'b', [0, 'd', ['e', 0]]]),
            ['a', {}, 'b', [{}, 'd', ['e', {}]]])
