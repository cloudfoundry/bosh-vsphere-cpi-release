from io import StringIO

import unittest

from pyVmomi.VmomiSupport import AddVersionParent

class TestAddVersionParent(unittest.TestCase):

    def setUp(self):
        self.out = StringIO()

    def test_simple(self):
        AddVersionParent('a', 'b', self.out)
        self.assertEqual(self.out.getvalue(),
            '    add_version_parent("a", "b")\n')
