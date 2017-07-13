import unittest

from pyvmomi_to_ruby.formatter import remove_trailing_empty_hash

class TestRemoveTrailingEmptyHash(unittest.TestCase):

    def test_none(self):
        self.assertEqual(remove_trailing_empty_hash(None), None)

    def test_empty_list(self):
        self.assertEqual(remove_trailing_empty_hash([]), [])

    def test_one_layer_does_not_have(self):
        self.assertEqual(remove_trailing_empty_hash(['a']), ['a'])

    def test_one_layer_has(self):
        self.assertEqual(remove_trailing_empty_hash(['a', {}]), ['a'])

    def test_two_layers_does_not_have(self):
        self.assertEqual(
            remove_trailing_empty_hash(['a', ['b']]), ['a', ['b']])

    def test_two_layers_has(self):
        self.assertEqual(
            remove_trailing_empty_hash(['a', ['b', {}]]), ['a', ['b']])

    def test_three_layers_does_not_have(self):
        self.assertEqual(remove_trailing_empty_hash(
            ['a', ['b', ['c']]]), ['a', ['b', ['c']]])

    def test_three_layers_has(self):
        self.assertEqual(remove_trailing_empty_hash(
            ['a', ['b', ['c', {}]]]), ['a', ['b', ['c']]])

    def test_tuple(self):
        self.assertEqual(remove_trailing_empty_hash(
            ['a', ('b', ('c', {})), {}]), ['a', ['b', ['c']]])
