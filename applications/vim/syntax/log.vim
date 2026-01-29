" Vim syntax file for log files
" Compatible with Vim 8.2+
" Enhanced version with additional highlighting patterns

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  if b:current_syntax == "log"
    finish
  endif
endif

" Case sensitive matching
syn case match

" Log Levels - ERROR, FATAL, CRITICAL
" Match ERROR in various contexts (after colon, as word, etc.)
syn match logError /\c\<\(ERROR\|FATAL\|CRITICAL\|CRIT\|FAIL\|FAILED\|FAILURE\|EXCEPTION\)\>/
syn match logError /\c\<\(PANIC\|ALERT\|EMERGENCY\|EMERG\)\>/
" Explicitly match ERROR after colon (e.g., ":ERROR:")
syn match logError /\c:\(ERROR\|FATAL\|CRITICAL\|CRIT\):/

" Log Levels - WARNING
syn match logWarning /\c\<\(WARN\|WARNING\|WARNINGS\)\>/
" Explicitly match WARNING after colon (e.g., ":WARNING:")
syn match logWarning /\c:\(WARN\|WARNING\):/

" Log Levels - INFO (must be defined before other patterns that might match)
syn match logInfo /\c\<\(INFO\|INFORMATION\|NOTICE\)\>/

" Log Levels - DEBUG, TRACE
syn match logDebug /\c\<\(DEBUG\|TRACE\|TRACING\|VERBOSE\)\>/

" Log Levels - SUCCESS, OK
syn match logSuccess /\c\<\(SUCCESS\|OK\|PASS\|PASSED\|SUCCEED\)\>/

" Module names - match word between application name and opening parenthesis or colon
" Pattern matches two formats:
" 1. date appname MODULENAME (numbers):LEVEL - e.g., "overseer (573.888899)(...):ERROR:"
" 2. date appname MODULENAME: - e.g., "stderr:"

" Generic module pattern for modules with parentheses (defined first, lower priority)
" Matches module name before opening parenthesis with numbers
syn match logModule /\s\zs[a-zA-Z0-9_-]\+\ze\s\+([0-9.]\+)/

" Specific module patterns for different colors (defined before generic, higher priority)
" These use \c for case-insensitive matching and should override the generic pattern
" Modules with parentheses
syn match logModuleOverseer /\c\s\zsoverseer\ze\s\+([0-9.]\+)/
syn match logModuleMonitor /\c\s\zsmonitor\ze\s\+([0-9.]\+)/
syn match logModuleTransceiver /\c\s\zstransceiver\ze\s\+([0-9.]\+)/
syn match logModuleCommon /\c\s\zscommon\ze\s\+([0-9.]\+)/

" Specific patterns for modules without parentheses (defined before generic, higher priority)
" stderr - always red
syn match logModuleStderr /\c\s\zsstderr\ze\s*:/
" stdout
syn match logModuleStdout /\c\s\zsstdout\ze\s*:/

" Generic module pattern for modules without parentheses (defined last, lower priority)
" Matches module name that is directly followed by colon (no parentheses pattern)
" Pattern: word followed by colon, where there's no opening parenthesis before the colon
" This should not match stderr/stdout since they're already matched above
syn match logModuleUnknown /\s\zs[a-zA-Z0-9_-]\+\ze:\%(\s\|$\)/

" Date and Time patterns
" ISO 8601: 2024-01-15T10:30:45.123Z
syn match logDate /\d\{4}-\d\{2}-\d\{2}T\d\{2}:\d\{2}:\d\{2}\(\.\d\+\)\?Z\?/
" ISO 8601 with timezone: 2024-01-15T10:30:45+00:00
syn match logDate /\d\{4}-\d\{2}-\d\{2}T\d\{2}:\d\{2}:\d\{2}\(\.\d\+\)\?[+-]\d\{2}:\d\{2}/
" Standard date: 2024-01-15 10:30:45
syn match logDate /\d\{4}-\d\{2}-\d\{2}\s\+\d\{2}:\d\{2}:\d\{2}\(\.\d\+\)\?/
" Date with slashes: 01/15/2024 10:30:45
syn match logDate /\d\{1,2}\/\d\{1,2}\/\d\{4}\s\+\d\{2}:\d\{2}:\d\{2}\(\.\d\+\)\?/
" Unix timestamp: 1705315845 or 1705315845.123
syn match logDate /\d\{10\}\(\.\d\+\)\?/
" Common log format: [15/Jan/2024:10:30:45 +0000]
syn match logDate /\[\d\{1,2\}\/[A-Z][a-z]\{2\}\/\d\{4\}:\d\{2}:\d\{2}:\d\{2}\s\+[+-]\d\{4\}\]/
" RFC 3339 variations
syn match logDate /\d\{4\}-\d\{2\}-\d\{2\}\s\+\d\{2\}:\d\{2\}:\d\{2\}/

" IP Addresses (IPv4)
syn match logIP /\<\(\d\{1,3\}\.\)\{3}\d\{1,3\}\>/
" IPv6 addresses (simplified pattern)
syn match logIP /\<\([0-9a-fA-F]\{0,4\}:\)\{2,7\}[0-9a-fA-F]\{0,4\}\>/

" MAC Addresses
syn match logMAC /\<\([0-9a-fA-F]\{2\}:\)\{5\}[0-9a-fA-F]\{2\}\>/
syn match logMAC /\<\([0-9a-fA-F]\{2\}-\)\{5\}[0-9a-fA-F]\{2\}\>/

" Hexadecimal numbers
syn match logHex /\<0x[0-9a-fA-F]\+\>/
syn match logHex /\<[0-9a-fA-F]\{8,}\>/

" UUIDs
syn match logUUID /\<[0-9a-fA-F]\{8\}-[0-9a-fA-F]\{4\}-[0-9a-fA-F]\{4\}-[0-9a-fA-F]\{4\}-[0-9a-fA-F]\{12\}\>/

" File paths (POSIX)
syn match logPath /\<\/[\/a-zA-Z0-9_.-]\+\>/
" File paths (Windows)
syn match logPath /\<[A-Z]:\\[\\a-zA-Z0-9_.-]\+\>/
" Relative paths
syn match logPath /\<\.\.\?\/[\/a-zA-Z0-9_.-]\+\>/
" File paths with line numbers: file.py:123
syn match logPath /\<[a-zA-Z0-9_.-]\+\.[a-zA-Z]\{2,4\}:\d\+\>/

" URLs
syn match logURL /\<https\?:\/\/[a-zA-Z0-9_.~:/?#[\]@!$&'()*+,;=-]\+\>/
syn match logURL /\<ftp:\/\/[a-zA-Z0-9_.~:/?#[\]@!$&'()*+,;=-]\+\>/

" HTTP Status Codes
syn match logHTTPStatus /\<\(1\|2\|3\|4\|5\)\d\{2\}\>/
syn match logHTTPStatus /\<HTTP\/[12]\.[01]\s\+\(1\|2\|3\|4\|5\)\d\{2\}\>/

" Port numbers (common ranges)
syn match logPort /:\d\{4,5\}\>/
syn match logPort /\c\<port\s\+\d\{1,5\}\>/

" Process IDs and Thread IDs
syn match logPID /\c\<\(PID\|pid\|process_id\)\s*[=:]\s*\d\+\>/
syn match logPID /\c\<\(TID\|tid\|thread_id\|thread\)\s*[=:]\s*\d\+\>/
syn match logPID /\c\[pid\s*\d\+\]/
syn match logPID /\c\[tid\s*\d\+\]/

" Stack traces
syn match logStackTrace /^\s*at\s\+[a-zA-Z0-9_.]\+\(\.java\|\.py\|\.js\|\.ts\|\.go\|\.rs\):\d\+/ contains=logPath
syn match logStackTrace /^\s*File\s\+"[^"]*",\s*line\s\+\d\+/ contains=logPath
syn match logStackTrace /^\s*in\s\+[a-zA-Z0-9_.]\+\(\.php\|\.rb\):\d\+/ contains=logPath

" Error messages and exceptions
syn match logException /\c\<\(Exception\|Error\|Throwable\|RuntimeException\)\>/
syn match logException /\c\<\(NullPointerException\|IllegalArgumentException\|IndexOutOfBoundsException\)\>/
syn match logException /\c\<\(KeyError\|ValueError\|AttributeError\|TypeError\)\>/
syn match logException /\c\<\(RuntimeError\|SyntaxError\|NameError\)\>/

" JSON-like structures (simple patterns)
syn match logJSON /{[^}]*}/
syn match logJSON /\[[^\]]*\]/

" Key-value pairs
syn match logKeyValue /\<[a-zA-Z_][a-zA-Z0-9_]*\s*[=:]\s*[^,}\s]\+\>/

" Numbers (integers and floats)
syn match logNumber /\<-\?\d\+\(\.\d\+\)\?\([eE][+-]\?\d\+\)\?\>/

" SQL queries (basic detection)
syn match logSQL /\c\<\(SELECT\|INSERT\|UPDATE\|DELETE\|CREATE\|ALTER\|DROP\)\s\+[^;]*;/

" HTTP methods
syn match logHTTPMethod /\<\(GET\|POST\|PUT\|DELETE\|PATCH\|HEAD\|OPTIONS\)\>/

" Status indicators
syn match logStatus /\<\(STARTED\|STOPPED\|RUNNING\|IDLE\|ACTIVE\|INACTIVE\)\>/
syn match logStatus /\<\(CONNECTED\|DISCONNECTED\|CONNECTING\|TIMEOUT\)\>/

" Boolean values
syn match logBoolean /\<\(true\|false\|True\|False\|TRUE\|FALSE\)\>/

" Null/None values
syn match logNull /\<\(null\|None\|NULL\|NONE\|nil\|Nil\)\>/

" Memory/Size values
syn match logSize /\c\<\(\d\+\(\.\d\+\)\?\)\s*\(KB\|MB\|GB\|TB\|bytes\|B\)\>/

" Duration/Time values
syn match logDuration /\c\<\(\d\+\(\.\d\+\)\?\)\s*\(ms\|s\|sec\|min\|hour\|h\|m\)\>/

" Define highlighting
" ERROR level - explicit red color
hi def logError ctermfg=1 cterm=bold guifg=#ff0000 gui=bold
" WARNING level - explicit yellow color
hi def logWarning ctermfg=3 cterm=bold guifg=#ffff00 gui=bold
" Use a consistent color for INFO (cyan/blue, not Question which varies)
hi def logInfo ctermfg=6 guifg=#00ffff
hi def link logDebug Comment
hi def link logSuccess String

" Module highlighting - different colors for different modules
" Default module color (for unknown modules with parentheses)
hi def logModule ctermfg=13 guifg=#ff00ff
" Unknown modules without parentheses (like stderr, stdout)
hi def logModuleUnknown ctermfg=8 guifg=#808080
" Specific modules can be customized
hi def logModuleOverseer ctermfg=11 guifg=#ffff00
hi def logModuleMonitor ctermfg=10 guifg=#00ff00
hi def logModuleTransceiver ctermfg=14 guifg=#00ffff
hi def logModuleCommon ctermfg=12 guifg=#0000ff
" stderr and stdout
hi def logModuleStderr ctermfg=9 cterm=bold guifg=#ff0000 gui=bold
hi def logModuleStdout ctermfg=11 guifg=#ffff00

hi def link logDate Constant
hi def link logIP Identifier
hi def link logMAC Identifier
hi def link logHex Number
hi def link logUUID Identifier
hi def link logPath Underlined
hi def link logURL Underlined

hi def link logHTTPStatus Number
hi def link logHTTPMethod Statement
hi def link logPort Number
hi def link logPID Number

hi def link logStackTrace Error
hi def link logException Error

hi def link logJSON String
hi def link logKeyValue Identifier
hi def link logNumber Number

hi def link logSQL Statement
hi def link logStatus Type
hi def link logBoolean Boolean
hi def link logNull Special
hi def link logSize Number
hi def link logDuration Number

let b:current_syntax = "log"











