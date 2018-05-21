from io import StringIO

import unittest

from pyVmomi.VmomiSupport import CreateDataType
from pyVmomi.VmomiSupport import F_LINK
from pyVmomi.VmomiSupport import F_LINKABLE
from pyVmomi.VmomiSupport import F_OPTIONAL
from pyVmomi.VmomiSupport import F_SECRET

class TestCreateDataType(unittest.TestCase):

    def setUp(self):
        self.out = StringIO()

    def test_e_none(self):
        CreateDataType('a', 'b', 'c', 'd', None, self.out)
        self.assertEqual(self.out.getvalue(),
            '    create_data_type("a", "b", "c", "d", nil)\n')

    def test_e_list(self):
        CreateDataType('a', 'b', 'c', 'd', [("f", "g", "h", 0)], self.out)
        self.assertEqual(self.out.getvalue(),
            '    create_data_type("a", "b", "c", "d", [["f", "g", "h"]])\n')

    def test_f(self):
        CreateDataType('a', 'b', 'c', 'd',
            [(F_LINK | F_LINKABLE | F_OPTIONAL | F_SECRET, 0)], self.out)
        self.assertEqual(self.out.getvalue(),
            '    create_data_type("a", "b", "c", "d", [[{:link => true, :linkable => true, :optional => true, :secret => true}]])\n')
