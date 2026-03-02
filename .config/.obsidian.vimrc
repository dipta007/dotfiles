" *************************************
" For More: https://github.com/chrisgrieser/.config/blob/c901268012930f1488db656b1f6396a5a1596ab5/obsidian/obsidian.vimrc
" *************************************

" Have j and k navigate visual lines rather than logical ones
nmap j gj
nmap k gk

" Yank to system clipboard
set clipboard=unnamed

" Go back and forward with Ctrl+O and Ctrl+I
" (make sure to remove default Obsidian shortcuts for these to work)
exmap back obcommand app:go-back
nmap <C-o> :back<CR>
exmap forward obcommand app:go-forward
nmap <C-i> :forward<CR>

" Also works
nmap <C-w>h :obcommand<space>workspace:split-horizontal<CR>

" [g]oto definition / link (shukuchi makes it forward-seeking)
exmap followNextLink obcommand shukuchi:open-link
nmap gd :followNextLink<CR>

" HACK temporary workaround, since shukuchi does not work in 1.4.0 on URLs
" exmap followLink obcommand editor:follow-link
" nmap gX :followLink<CR>
