import unittest

from pyvmomi_to_ruby.formatter import format_value
from pyvmomi_to_ruby.or_list import OrList

class TestFormatValue(unittest.TestCase):

    def test_none(self):
        self.assertEqual(format_value(None), 'nil')

    def test_orlist(self):
        self.assertEqual(format_value(OrList(['a', 'b'])),
            '{:a => true, :b => true}')

    def test_list(self):
        self.assertEqual(format_value(['a', 'b']), '["a", "b"]')

    def test_tuple(self):
        self.assertEqual(format_value(('a', 'b')), '["a", "b"]')

    def test_int(self):
        self.assertEqual(format_value(100), '100')

    def test_str(self):
        self.assertEqual(format_value('x'), '"x"')

    def test_mixed(self):
        self.assertEqual(format_value([
            None,
            OrList(['a', 'b']),
            ['a', 'b'],
            ('a', 'b'),
            100,
            'x',
            ]),
            '[nil, {:a => true, :b => true}, ["a", "b"], ["a", "b"], 100, "x"]')

    def test_nested(self):
        self.assertEqual(format_value([[[OrList(['a', 'b'])]]]),
            '[[[{:a => true, :b => true}]]]')
