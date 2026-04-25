# Void's NPC Manager v0.3.0
- removed `load_dialogue_pools()` and `_load_dgpool_file()` from engine.gd
- changed all instances of `make_dir_recursive() to `make_dir_recursive_absolute()`
- renamed Dialogue_Syntax.md to DialogueSyntax.md and added GettingStarted.md


# Dgpool Extension v0.2.0
- compile folder renamed to parse folder
- parser.gd renamed to DialogueCache.gd and no longer does runtime parsing and now just does lookups of stored data
- added ScriptData.gd to create ScriptData resources
- parser_validatoe.gd renamed to Parser.gd


# Note
Extensive testing is not being carried out between minor updates. Though Tests are still carried out
