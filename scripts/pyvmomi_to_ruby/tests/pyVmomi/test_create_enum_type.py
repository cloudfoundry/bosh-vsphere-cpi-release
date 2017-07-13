from io import StringIO

import unittest

from pyVmomi.VmomiSupport import CreateEnumType

class TestCreateEnumType(unittest.TestCase):

    def setUp(self):
        self.out = StringIO()

    def test_mixed(self):
        CreateEnumType('a', 'b', 'c', None, self.out)
        self.assertEqual(self.out.getvalue(),
            '    create_enum_type("a", "b", "c", nil)\n')
