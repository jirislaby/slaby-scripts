import re

import pygit2


class SlRepository(pygit2.Repository):
    def grep(self, pattern: str | re.Pattern, ref: str | pygit2.Commit | pygit2.Tree = "HEAD"):
        """
        Grep for a pattern in the repository.

        :param pattern: The pattern to search for.
        :param ref: The reference to search in (default is HEAD).
        :return: A list of (file path, line number, matching line) tuples.
        """
        matches = []
        if isinstance(ref, pygit2.Tree):
            tree = ref
        else:
            if isinstance(ref, pygit2.Commit):
                commit = ref
            else:
                commit = self.revparse_single(ref)
            tree = commit.tree

        if isinstance(pattern, str):
            pattern = re.compile(pattern)

        for entry in tree:
            if entry.type == pygit2.enums.ObjectType.BLOB:
                blob = self[entry.id]
                if blob.is_binary:
                    continue
                content = blob.data.decode('utf-8', errors='ignore')
                for line_number, line in enumerate(content.splitlines(), start=1):
                    if pattern.search(line):
                        matches.append((entry.name, line_number, line))
            elif entry.type == pygit2.enums.ObjectType.TREE:
                sub_tree = self[entry.id]
                for match in self.grep(pattern, sub_tree):
                    matches.append((f"{entry.name}/{match[0]}", match[1], match[2]))

        return matches
