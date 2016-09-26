#!/bin/bash
# Replace text "A BC" with "XY Z" in file.txt
sed -i '' -e "s/A BC/XY Z/" file.txt

# Replace text "<!-- FOO BAR -->" in file.txt with text from other_file.txt
sed -i '' -e "s/<\!-- FOO BAR -->/$(sed 's:/:\\/:g' other_file.txt)/" file.txt
