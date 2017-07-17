from io import StringIO

import unittest

from pyVmomi.VmomiSupport import AddVersion

class TestAddVersion(unittest.TestCase):

    def setUp(self):
        self.out = StringIO()

    def test_d_0(self):
        AddVersion('a', 'b', 'c', 0, 'e', self.out)
        self.assertEqual(self.out.getvalue(),
            '    add_version("a", "b", "c", false, "e")\n')

    def test_d_1(self):
        AddVersion('a', 'b', 'c', 1, 'e', self.out)
        self.assertEqual(self.out.getvalue(),
            '    add_version("a", "b", "c", true, "e")\n')
