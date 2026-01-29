" Filetype detection for log files
" Compatible with Vim 8.2+

" Detect log files by extension
au BufNewFile,BufRead *.log setfiletype log
au BufNewFile,BufRead *.log.* setfiletype log

" Detect log files by name patterns
au BufNewFile,BufRead *access.log* setfiletype log
au BufNewFile,BufRead *error.log* setfiletype log
au BufNewFile,BufRead *access_log* setfiletype log
au BufNewFile,BufRead *error_log* setfiletype log
au BufNewFile,BufRead *application.log* setfiletype log
au BufNewFile,BufRead *app.log* setfiletype log
au BufNewFile,BufRead *system.log* setfiletype log
au BufNewFile,BufRead *syslog* setfiletype log
au BufNewFile,BufRead *messages* setfiletype log
au BufNewFile,BufRead *debug.log* setfiletype log
au BufNewFile,BufRead *trace.log* setfiletype log

" Detect log files in common log directories
au BufNewFile,BufRead /var/log/* setfiletype log
au BufNewFile,BufRead /var/log/**/* setfiletype log











