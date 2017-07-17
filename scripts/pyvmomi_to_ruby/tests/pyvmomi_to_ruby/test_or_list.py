import unittest

from pyvmomi_to_ruby.or_list import OrList

class TestOrList(unittest.TestCase):

    def test_or(self):
        list1 = OrList(['a', 'b'])
        list2 = OrList(['c', 'd'])

        self.assertEqual(list1 | list2, ['a', 'b', 'c', 'd'])

    def test_str(self):
        list1 = OrList(['a', 'b'])
        list2 = OrList(['c', 'd'])

        self.assertEqual(str(list1 | list2),
            '{:a => true, :b => true, :c => true, :d => true}')
