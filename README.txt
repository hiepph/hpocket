My personal Firefox's pocket (bookmark manager) written in Haskell.

i:link --> hpocket -> [link]
        |
q:query |

+ `i` (insert): insert link's title + content into database
e.g. hpocket "i:http://example.com"
+ `q` (query): full text search for title + content
e.g. hpocket "q:example"
