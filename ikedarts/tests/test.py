#!/usr/bin/env python
# -*- coding: utf-8 -*-
import sys,os
from pprint import pprint
import unittest
import ikedarts

class TestIkeDarts(unittest.TestCase):

    def setUp(self):
        pass

    def test_basic(self):
        """test basic operations of darts
        """
        words="""
bar
baz
foo
foobar
"""
        # compile the dictionary file
        darts_file,status,out,err=ikedarts.mkdarts(words.split('\n'))
        self.assertEqual(status,0)
        self.assertTrue(os.path.exists(darts_file))

        ikd=ikedarts.IkeDarts(darts_file)
        result=ikd.search('oh hai foo foobar hobaz somebar hoge')
        self.assertEqual(result,
                         [
                # whole words are obviously found.
                {'entry': 'foo', 'key': 2, 'offset': 7},

                # entry that is a prefix is also found
                {'entry': 'foo', 'key': 2, 'offset': 11},

                # longer entries are also found.
                # ie all entries that are prefixes at a point in the documents are found.
                # Note, however, that 'bar' embedded in 'foobar' is missed.
                # So an entry is shadowed by a preceeding match. This is a known limitation.
                {'entry': 'foobar', 'key': 3, 'offset': 11},

                # match in the middle of a word.
                {'entry': 'baz', 'key': 1, 'offset': 20},

                # If the preceeding prefix is not matched, an embedded bar is found.
                # To summarise:
                #   bar in foobar is missed since foo matched.
                #   bar in somebar is matched since some is not an entry.
                {'entry': 'bar', 'key': 0, 'offset': 28},
                ]
                         )


if __name__=='__main__':

    unittest.main()

